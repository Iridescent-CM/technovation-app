class SyncBackgroundChecksJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    admin_profile_id = job.arguments[0][:admin_profile_id]
    profile_type = "AdminProfile"

    profile = profile_type.constantize.find(admin_profile_id)

    Job.create!(job_id: job.job_id, status: "queued", owner: profile)
  end

  after_perform do |job|
    db_job = Job.find_by(job_id: job.job_id)
    db_job.update_column(:status, "complete")
  end

  def perform(admin_profile_id)
    accounts = Account.current.joins(:background_check).where.not(background_checks: {status: :clear})

    accounts.find_each do |account|
      CheckrApiClient::SyncBackgroundCheck.new(account: account).call
    end
  end
end
