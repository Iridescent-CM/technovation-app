require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      current_mentor.current_teams.each do |team|
        FillPdfs.(current_account, team)
      end

      redirect_to mentor_dashboard_path, success: "Your certificate is ready!"
    end
  end
end
