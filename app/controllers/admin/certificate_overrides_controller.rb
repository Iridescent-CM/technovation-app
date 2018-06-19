module Admin
  class CertificateOverridesController < AdminController
    def create
      account = Account.find(params.fetch(:account_id))

      parammed_type = override_params.fetch(:override_certificate_type)
      type_converted_to_int = Account.override_certificate_types[parammed_type]

      OverrideCertificate.(account, type_converted_to_int)

      render json: {
        flash: {
          success: "You overrode the certificate for #{account.name}",
        },
      }
    end

    private
    def override_params
      params.require(:account).permit(:override_certificate_type)
    end
  end
end