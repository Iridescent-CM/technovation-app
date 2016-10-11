class Screenshot < ActiveRecord::Base
  belongs_to :team_submission

  mount_uploader :image, ScreenshotProcessor
end
