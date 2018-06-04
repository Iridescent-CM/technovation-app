require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      FillPdfs.(current_mentor)
      redirect_to mentor_dashboard_path, success: "Your certificate is ready!"
    end
  end
end
