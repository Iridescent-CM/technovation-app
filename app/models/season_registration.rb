class SeasonRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :registerable, polymorphic: true

  def self.register(registerable, season = Season.current)
    find_or_create_by(registerable: registerable, season: season)
  end
end
