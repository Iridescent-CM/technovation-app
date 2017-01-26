class ProcessScreenshotsJob < ActiveJob::Base
  queue_as :default

  attr_accessor :jid

  around_enqueue do |job, block|
    job.jid = block.call
  end

  def perform(record, keys)
    keys.each do |key|
      url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
      record.screenshots.create!({
        remote_image_url: url,
      })
    end
  end
end
