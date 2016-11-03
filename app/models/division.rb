class Division < ActiveRecord::Base
  SENIOR_DIVISION_AGE = 15

  enum name: [:senior, :junior, :none_assigned_yet]

  validates :name, uniqueness: { case_sensitive: false },
                   presence: true,
                   inclusion: { in: names.keys + names.values + names.keys.map(&:to_sym) }

  def self.senior
    find_or_create_by(name: names[:senior])
  end

  def self.junior
    find_or_create_by(name: names[:junior])
  end

  def self.none_assigned_yet
    find_or_create_by(name: names[:none_assigned_yet])
  end

  def self.for(record)
    if !!record
      division_for(record)
    else
      none_assigned_yet
    end
  end

  private
  def self.division_for(record)
    case record.class.name
    when "StudentProfile"
      division_by_age(record)
    when "Team"
      division_by_team_ages(record)
    else
      none_assigned_yet
    end
  end

  def self.division_by_age(account)
    Timecop.freeze(Date.new(Season.current.year, 8, 1)) do
      return account.age < SENIOR_DIVISION_AGE ? junior : senior
    end
  end

  def self.division_by_team_ages(team)
    divisions = team.reload.students.collect { |s| division_by_age(s) }
    if divisions.any?
      divisions.flat_map(&:name).include?(senior.name) ? senior : junior
    else
      none_assigned_yet
    end
  end
end
