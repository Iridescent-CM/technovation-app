class Season < ActiveRecord::Base
  has_many :registrations

  validates :year, presence: true,
                   numericality: true,
                   uniqueness: { case_sensitive: false }
  validates :starts_at, presence: true

  def self.current
    season_year = if Date.today < switch_date
                    Date.today.year
                  else
                    Date.today.year + 1
                  end

    find_or_create_by(year: season_year,
                      starts_at: Time.new(season_year, 1, 1, 9, 0, 0, "-08:00"))
  end

  def self.for(record)
    season_year = if record.created_at < switch_date(record.created_at.year)
                    record.created_at.year
                  else
                    record.created_at.year + 1
                  end

    find_or_create_by(year: season_year,
                      starts_at: Time.new(season_year, 1, 1, 9, 0, 0, "-08:00"))
  end

  def self.switch_date(year = Time.current.year)
    Date.new(year, 8, 1)
  end
end
