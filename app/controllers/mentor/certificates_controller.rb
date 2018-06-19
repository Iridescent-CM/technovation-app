require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      current_mentor.current_teams.each do |team|
        job_id = CertificateJob.perform_later(current_mentor.account_id, team.id)
      end

      redirect_to mentor_dashboard_path, success: "Your certificate is ready!"
    end
  end
end
