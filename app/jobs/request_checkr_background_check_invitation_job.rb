class RequestCheckrBackgroundCheckInvitationJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    account_id = job.arguments[0][:account_id]
    profile = Account.find(account_id)

    Job.create!(
      job_id: job.job_id,
      status: "queued",
      owner: profile
    )

    bg_check = BackgroundCheck.find_or_create_by!(account: profile)
    bg_check.update_columns(
      status: :invitation_required,
      state: :requesting_invitation
    )
  end

  after_perform do |job|
    db_job = Job.find_by(job_id: job.job_id)
    db_job.update_column(:status, "complete")
  end

  def perform(account_id:)
    candidate = Account.find(account_id)
    CheckrApiClient::ApiClient.new(candidate: candidate).request_checkr_invitation
  end
end
