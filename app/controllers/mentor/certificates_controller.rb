require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      job = CertificateJob.perform_later(
        current_mentor.account_id,
        params.fetch(:team_id),
      )

      render json: { jobId: job.job_id }
    end
  end
end
