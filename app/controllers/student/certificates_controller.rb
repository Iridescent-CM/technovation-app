require "fill_pdfs"

module Student
  class CertificatesController < StudentController
    def create
      FillPdfs.(CertificateRecipient.new(current_student), cert_params[:type])

      redirect_to student_dashboard_path,
        success: "Your completion certificate is ready!"
    end

    private
    def cert_params
      params.permit(:type)
    end
  end
end
