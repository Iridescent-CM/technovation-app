require "fill_pdfs"

module Student
  class CertificatesController < StudentController
    def create
      FillPdfs.(current_account, team: current_team)
      redirect_to student_dashboard_path, success: "Your certificate is ready!"
    end
  end
end
