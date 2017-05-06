module Legacy
  module V2
    module RegionalAmbassador
      class AccountsController < RegionalAmbassadorController
        def update
          current_ambassador.account.update_attributes(account_params)

          redirect_to regional_ambassador_dashboard_path,
            notice: "Your account settings were saved"
        end

        private
        def account_params
          params.require(:account).permit(
            :timezone,
          )
        end
      end
    end
  end
end
