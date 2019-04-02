require 'fill_pdfs'

class CertificateJob < ActiveJob::Base
  queue_as :default

  before_enqueue do |job|
    recipient = CertificateRecipient.from_state(job.arguments.first)
    owner = recipient.account

    Job.create!(
      job_id: job.job_id,
      status: "queued",
      owner: owner,
    )
  end

  after_perform do |job|
    if db_job = Job.find_by(job_id: job.job_id)
      recipient = CertificateRecipient.from_state(job.arguments.first)

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

  def perform(certificate_recipient_state)
    FillPdfs.fill(CertificateRecipient.from_state(certificate_recipient_state))
  end
end
