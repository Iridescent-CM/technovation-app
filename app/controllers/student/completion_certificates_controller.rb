require "fill_pdfs"

module Student
  class CompletionCertificatesController < StudentController
    def create
      student_data = {
        'id' => current_student.account_id,
        'Recipient Name' => current_student.full_name,
        'app name' => current_team.submission.app_name,
      }

      FillPdfs.(student_data, :completion)

      redirect_to student_dashboard_path,
        success: "Your completion certificate is ready!"
    end
  end
end
