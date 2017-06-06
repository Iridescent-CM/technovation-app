require "fill_pdfs"

module Student
  class CertificatesController < StudentController
    def create
      student_data = {
        'id' => current_student.account_id,
        'Recipient Name' => current_student.full_name,
        'app name' => current_team.submission.app_name,
      }

      if cert_params[:type] == "rpe_winner"
        student_data["Region Name"] = [
          FriendlySubregion.(current_student.account, prefix: false),
          FriendlyCountry.(current_student.account, prefix: false)
        ].compact.join(", ")
      end

      FillPdfs.(student_data, cert_params[:type])

      redirect_to student_dashboard_path,
        success: "Your completion certificate is ready!"
    end

    private
    def cert_params
      params.permit(:type)
    end
  end
end
