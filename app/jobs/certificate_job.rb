require 'fill_pdfs'

class CertificateJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    account_id = job.arguments.first
    owner = Account.find(account_id)

    Job.create!(
      job_id: job.job_id,
      status: "queued",
      owner: owner,
    )
  end

  after_perform do |job|
    if db_job = Job.find_by(job_id: job.job_id)
      db_job.update_columns(
        status: "complete",
        payload: {
          file_url: db_job.owner.current_certificates.last.file_url,
        },
      )
    end
  end

  def perform(account_id, team_id = nil)
    account = Account.find(account_id)

    team = if team_id
             Team.find(team_id)
           else
             nil
           end

    FillPdfs.(account, team)
  end
end