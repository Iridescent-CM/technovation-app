class Season < ActiveRecord::Base
  has_many :registrations, class_name: "SeasonRegistration"

  validates :year,
    presence: true,
    numericality: true,
    uniqueness: { case_sensitive: false }

  def self.current
    if Date.today < switch_date
      find_or_create_by(year: Date.today.year)
    else
      find_or_create_by(year: Date.today.year + 1)
    end
  end

  def self.for(record)
    if record.created_at < switch_date(record.created_at.year)
      find_or_create_by(year: record.created_at.year)
    else
      find_or_create_by(year: record.created_at.year + 1)
    end
  end

  def self.switch_date(year = Time.current.year)
    Date.new(year, 8, 1)
  end
end
