require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      FillPdfs.(CertificateRecipient.new(current_mentor), cert_params[:type])

      redirect_to mentor_dashboard_path,
        success: "Your #{cert_params[:type]} certificate is ready!"
    end

    private
    def cert_params
      params.permit(:type)
    end
  end
end
