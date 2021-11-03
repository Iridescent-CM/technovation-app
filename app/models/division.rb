class Division < ActiveRecord::Base
  SENIOR_DIVISION_AGE = 16

  enum name: {
    beginner: 3,
    junior: 1,
    senior: 0,
    none_assigned_yet: 2
  }

  validates :name,
    uniqueness: {case_sensitive: false},
    presence: true,
    inclusion: {in: names.keys + names.values + names.keys.map(&:to_sym)}

  def self.senior
    find_or_create_by(name: names[:senior])
  end

  def self.junior
    find_or_create_by(name: names[:junior])
  end

  def self.beginner
    find_or_create_by(name: names[:beginner])
  end

  def self.none_assigned_yet
    find_or_create_by(name: names[:none_assigned_yet])
  end

  def self.for(record)
    return none_assigned_yet if record.blank?

    case record.class.name
    when "StudentProfile", "Account"
      for_account(record)
    when "Team"
      for_team(record)
    else
      none_assigned_yet
    end
  end

  def self.for_account(account)
    case account.age_by_cutoff
    when 8..12
      beginner
    when 13..15
      junior
    else
      senior
    end
  end

  def self.for_team(team)
    divisions = Membership.where(
      team: team,
      member_type: "StudentProfile"
    ).map(&:member).collect { |student_profile| for_account(student_profile.account) }

    if divisions.any?
      division_names = divisions.flat_map(&:name)

      if division_names.include?(senior.name)
        senior
      elsif division_names.include?(junior.name)
        junior
      elsif division_names.include?(beginner.name)
        beginner
      else
        none_assigned_yet
      end
    end
  end

  def self.cutoff_date
    ImportantDates.division_cutoff
  end
end
