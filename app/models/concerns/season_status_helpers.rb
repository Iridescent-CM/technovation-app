module SeasonStatusHelpers
  extend ActiveSupport::Concern

  def active_for_current_season?
    seasons.include?(Season.current.year)
  end

  def mark_active_for_current_season
    update(seasons: seasons << Season.current.year)
  end

  def mark_inactive_for_current_season
    update(seasons: seasons - [Season.current.year])
  end
end
