class Division < ActiveRecord::Base
  enum name: [:high_school, :middle_school, :none_assigned]

  validates :name, uniqueness: { case_sensitive: false },
                   presence: true,
                   inclusion: { in: names.keys + names.values + names.keys.map(&:to_sym) }

  def self.high_school
    find_or_create_by(name: names[:high_school])
  end

  def self.middle_school
    find_or_create_by(name: names[:middle_school])
  end

  def self.none_assigned
    find_or_create_by(name: names[:none_assigned])
  end

  def self.for(account)
    if !!account
      case account.type
      when "MentorAccount"
        none_assigned
      else
        account.is_in_secondary_school? ? high_school : middle_school
      end
    else
      none_assigned
    end
  end
end
