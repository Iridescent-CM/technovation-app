class Screenshot < ActiveRecord::Base
  belongs_to :team_submission, touch: true

  before_create -> {
    self.sort_position = (self.class.maximum(:sort_position) || -1) + 1
  }

  def self.persisted
    select(&:persisted?)
  end

  def image_url
    if image.include?("filestackcontent")
      image
    else
      # This only applies to the old submission screenshots that were uploaded to S3 before 2023 season
      "https://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/uploads/screenshot/image/#{id}/#{image}"
    end
  end
end
