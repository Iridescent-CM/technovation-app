module StatusHelpers
  extend ActiveSupport::Concern

  def active?
    seasons.include?(Season.current.year)
  end

  def mark_active
    update(seasons: seasons << Season.current.year)
  end

  def mark_inactive
    update(seasons: seasons - [Season.current.year])
  end
end
