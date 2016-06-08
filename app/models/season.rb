class Season < ActiveRecord::Base
  has_many :registrations

  validates :year, presence: true, numericality: true, uniqueness: true
  validates :starts_at, presence: true

  def self.current
    find_by(year: Time.current.year)
  end
end
