module StatusHelpers
  extend ActiveSupport::Concern

  def active?
    seasons.include?(Season.current.year)
  end

  def inactive?
    !active?
  end

  def activate
    update(seasons: seasons << Season.current.year)
  end

  def deactivate
    update(seasons: seasons - [Season.current.year])
  end
end
