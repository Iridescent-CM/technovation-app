module Legacy
  module V2
    class ConsentWaiversController < ApplicationController
      def show
        @consent_waiver = ConsentWaiver.find(params.fetch(:id))
      end

      def new
        if valid_token?
          @consent_waiver = ConsentWaiver.new(account_consent_token: params.fetch(:token))
        else
          redirect_to application_dashboard_path,
                      alert: t("controllers.consent_waivers.new.unauthorized")
        end
      end

      def create
        @consent_waiver = ConsentWaiver.new(consent_waiver_params)

        if @consent_waiver.save
          redirect_to send("#{@consent_waiver.account_type_name}_dashboard_path"),
                      success: t("controllers.consent_waivers.create.success")
        else
          render :new
        end
      end

      private
      def valid_token?
        Account.exists?(consent_token: params.fetch(:token) { "" })
      end

      def consent_waiver_params
        params.require(:consent_waiver).permit(:account_consent_token,
                                              :electronic_signature)
      end
    end
  end
end
