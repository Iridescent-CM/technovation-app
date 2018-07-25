require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      team_id = params.fetch(:team_id)

      certificate = current_mentor.current_certificates.find_by(
        team_id: team_id
      )

      if certificate.present?
        render json: {
          status: "complete",
          payload: {
            fileUrl: certificate.file_url,
          },
        }
      else
        job = CertificateJob.perform_later(
          current_mentor.account_id,
          team_id,
        )

        render json: { jobId: job.job_id }
      end
    end
  end
end
