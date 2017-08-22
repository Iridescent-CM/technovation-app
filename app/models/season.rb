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

  def self.next
    nxt = current

    unless SeasonToggles.registration_closed? and
             Date.today >= switch_date
      nxt.year += 1
    end

    nxt
  end

  def self.for(record)
    if record.created_at < switch_date(record.created_at.year)
      find_or_create_by(year: record.created_at.year)
    else
      find_or_create_by(year: record.created_at.year + 1)
    end
  end

  def self.switch_date(year = Time.current.year)
    Date.new(year, switch_month, switch_day)
  end

  def self.switch_month
    10
  end

  def self.switch_day
    1
  end
end
