class Division < ActiveRecord::Base
  enum name: [:high_school, :middle_school]

  validates :name, uniqueness: true,
                   presence: true,
                   inclusion: { in: names.keys + names.values + names.keys.map(&:to_sym) }

  def self.high_school
    find_or_create_by(name: names[:high_school])
  end

  def self.middle_school
    find_or_create_by(name: names[:middle_school])
  end

  def self.for(account)
    account.is_in_secondary_school? ? high_school : middle_school
  end
end
