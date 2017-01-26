class ProcessScreenshotsJob < ActiveJob::Base
  queue_as :default

  around_enqueue do |job, block|
    db_job = Job.create!(job_id: job.job_id, status: "queued")
    block.call
    db_job.update_column(:status, "complete")
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
