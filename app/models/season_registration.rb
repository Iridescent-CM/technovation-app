class SeasonRegistration < ActiveRecord::Base
  belongs_to :season
  belongs_to :registerable, polymorphic: true

  def self.register(registerable)
    create(registerable: registerable, season: Season.current)
  end
end
