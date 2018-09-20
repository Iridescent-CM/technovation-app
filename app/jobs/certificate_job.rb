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
      options = job.arguments.last

      if options.is_a?(Hash)
        cert = if options[:past_allowed]
          db_job.owner.certificates.last
        else
          db_job.owner.current_certificates.last
        end
      else
        cert = db_job.owner.current_certificates.last
      end

      if cert
        db_job.update_columns(
          status: "complete",
          payload: {
            fileUrl: cert.file_url,
          },
        )
      else
        db_job.update_columns(
          status: "failed",
        )
      end
    end
  end

  def perform(account_id, team_id = nil, **options)
    account = Account.find(account_id)

    team = if team_id
             Team.find(team_id)
           else
             nil
           end

    FillPdfs.(account, team)
  end
end