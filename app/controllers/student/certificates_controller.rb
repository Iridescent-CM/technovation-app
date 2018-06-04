require "fill_pdfs"

module Student
  class CertificatesController < StudentController
    def create
      FillPdfs.(current_student)
      redirect_to student_dashboard_path, success: "Your certificate is ready!"
    end
  end
end
