class Screenshot < ActiveRecord::Base
  belongs_to :team_submission

  mount_uploader :image, ScreenshotProcessor

  before_create -> {
    self.sort_position = (self.class.maximum(:sort_position) || -1) + 1
  }
end
