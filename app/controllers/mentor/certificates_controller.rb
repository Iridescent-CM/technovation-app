require "fill_pdfs"

module Mentor
  class CertificatesController < MentorController
    def create
      mentor_data = {
        'id' => current_mentor.account_id,
        'Recipient Name' => current_mentor.full_name,
        'Region Name' => [
          FriendlySubregion.(current_mentor.account, prefix: false),
          FriendlyCountry.(current_mentor.account, prefix: false)
        ].compact.join(", "),
      }

      FillPdfs.(mentor_data, cert_params[:type])

      redirect_to mentor_dashboard_path,
        success: "Your #{cert_params[:type]} certificate is ready!"
    end

    private
    def cert_params
      params.permit(:type)
    end
  end
end
