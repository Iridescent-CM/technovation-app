class SeasonRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :registerable, polymorphic: true

  def self.register(registerable, season = Season.current)
    if not exists?(registerable: registerable, season: season)
      create(registerable: registerable, season: season)
      registerable.after_registration
    end
  end
end
