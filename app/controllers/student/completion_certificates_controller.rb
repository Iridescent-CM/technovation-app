require "fill_pdfs"

module Student
  class CompletionCertificatesController < StudentController
    def create
      FillPdfs.(current_student.account, :completion)
      redirect_to student_dashboard_path,
        success: "Your completion certificate is ready!"
    end
  end
end
