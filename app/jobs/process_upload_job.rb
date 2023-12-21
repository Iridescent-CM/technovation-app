class ProcessUploadJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    klass = job.arguments[1].constantize

    Job.create!(
      owner: klass.find(job.arguments[0]),
      job_id: job.job_id,
      status: "queued"
    )
  end

  after_perform do |job|
    if db_job = Job.find_by(job_id: job.job_id)
      db_job.update(status: "complete")
    end
  end

  def perform(record_id, klass, method_name, key, account_id = nil)
    record = klass.constantize.find(record_id)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    record.send("remote_#{method_name}_url=", url)

    case klass
    when "Account"
      record.icon_path = nil
    when "TeamSubmission"
      if method_name == "source_code"
        submission = TeamSubmission.friendly.find(record_id)
        account = Account.find(account_id)

        submission.team.create_activity(
          trackable: account,
          key: "submission.update",
          parameters: {piece: "source_code_url"},
          recipient: submission
        )
      end
    end

    record.save!
  end
end
