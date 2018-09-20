require "fill_pdfs"

module Admin
  class CertificatesController < AdminController
    def create
      team_id = params.fetch(:team_id)
      profile = params.fetch(:profile_type).constantize.find(params.fetch(:profile_id))

      certificate = profile.current_certificates.find_by(
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
          profile.account_id,
          team_id,
        )

        render json: { jobId: job.job_id }
      end
    end
  end
end
