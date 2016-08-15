class Division < ActiveRecord::Base
  DIVISION_A_AGE = 14

  enum name: [:a, :b, :none_assigned]

  validates :name, uniqueness: { case_sensitive: false },
                   presence: true,
                   inclusion: { in: names.keys + names.values + names.keys.map(&:to_sym) }

  def self.a
    find_or_create_by(name: names[:a])
  end

  def self.b
    find_or_create_by(name: names[:b])
  end

  def self.none_assigned
    find_or_create_by(name: names[:none_assigned])
  end

  def self.for(account)
    if !!account
      case account.type
      when "StudentAccount"
        division_by_age(account)
      else
        none_assigned
      end
    else
      none_assigned
    end
  end

  def self.division_by_age(account)
    account.age < DIVISION_A_AGE ? b : a
  end
end
