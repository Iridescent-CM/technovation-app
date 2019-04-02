require 'fill_pdfs'

class CertificateJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    account_id = job.arguments.second
    owner = Account.find(account_id)

    Job.create!(
      job_id: job.job_id,
      status: "queued",
      owner: owner,
    )
  end

  after_perform do |job|
    if db_job = Job.find_by(job_id: job.job_id)
      certificate_type = job.arguments[0]
      account = Account.find(job.arguments[1])

      team = if job.arguments[2]
               Team.find(job.arguments[2])
             else
               nil
             end

      recipient = CertificateRecipient.new(certificate_type, account, team: team)

      if recipient.certificate_issued?
        #FIXME: using .last here is still a bit risky
        cert = recipient.certificates.last
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

  def perform(certificate_type, account_id, team_id = nil, **options)
    account = Account.find(account_id)

    team = if team_id
             Team.find(team_id)
           else
             nil
           end

    FillPdfs.fill(CertificateRecipient.new(certificate_type, account, team: team))
  end
end
