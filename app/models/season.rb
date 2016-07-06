class Season < ActiveRecord::Base
  has_many :registrations

  validates :year, presence: true, numericality: true, uniqueness: true
  validates :starts_at, presence: true

  def self.create_current(starts_at = Time.current)
    find_or_create_by(year: Time.current.year, starts_at: starts_at)
  end

  def self.current
    find_by(year: Time.current.year)
  end
end
