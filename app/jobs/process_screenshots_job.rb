class ProcessScreenshotsJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    Job.create!(job_id: job.job_id, status: "pending")
  end

  after_enqueue do |job|
    db_job = Job.find_by(job_id: job.job_id)
    db_job.update_column(:status, "queued")
  end

  after_perform do |job|
    db_job = Job.find_by(job_id: job.job_id)
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
