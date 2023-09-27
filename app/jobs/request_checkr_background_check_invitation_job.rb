class RequestCheckrBackgroundCheckInvitationJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    profile = job.arguments[0][:candidate]

    Job.create!(
      job_id: job.job_id,
      status: "queued",
      owner: profile
    )
  end

  after_perform do |job|
    db_job = Job.find_by(job_id: job.job_id)
    db_job.update_column(:status, "complete")
  end

  def perform(candidate:)
    CheckrApiClient::ApiClient.new.request_checkr_invitation(candidate: candidate)
  end
end
