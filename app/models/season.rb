class Season < ActiveRecord::Base
  has_many :registrations

  validates :year, presence: true,
                   numericality: true,
                   uniqueness: { case_sensitive: false }
  validates :starts_at, presence: true

  def self.current
    find_or_create_by(year: CurrentSeasonYear.(),
                      starts_at: DefaultSeasonStartTime.())
  end
end
