class ProcessScreenshotsJob < ActiveJob::Base
  queue_as :default

  def perform(record, key)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    record.screenshots.create!({
      remote_image_url: url,
    })
  end
end
