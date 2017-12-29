class Screenshot < ActiveRecord::Base
  MAX_ALLOWED = 6

  belongs_to :team_submission, touch: true

  mount_uploader :image, ScreenshotProcessor

  before_create -> {
    self.sort_position = (self.class.maximum(:sort_position) || -1) + 1
  }

  def self.persisted
    select(&:persisted?)
  end

  def self.max_files_remaining(submission)
    MAX_ALLOWED - submission.screenshots.persisted.count
  end

  def self.while_files_remaining(submission, &block)
    if max_files_remaining(submission) > 0
      yield
    end
  end

  def self.while_none_remaining(submission, &block)
    unless max_files_remaining(submission) > 0
      yield
    end
  end

  def self.while_any(submission, &block)
    if submission.screenshots.persisted.any?
      yield
    end
  end
end
