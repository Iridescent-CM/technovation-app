class Season < ActiveRecord::Base
  has_many :registrations

  def self.current
    find_by(year: Time.current.year)
  end
end
