require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      team_id = params.fetch(:team_id)

      if current_mentor.current_certificates.exists?(team_id: team_id)
        render json: {
          status: "complete",
          payload: {
            fileUrl: current_mentor.current_certificates.last.file_url,
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
