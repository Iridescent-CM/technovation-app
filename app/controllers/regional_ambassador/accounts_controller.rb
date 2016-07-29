module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    include AccountController

    private
    def account
      @account ||= RegionalAmbassadorAccount.find_with_token(cookies.fetch(:auth_token) { "" })
    end

    def edit_account_path
      edit_regional_ambassador_account_path
    end

    def account_param_root
      :regional_ambassador_account
    end

    def profile_params
      {
        regional_ambassador_profile_attributes: [
          :id,
          :organization_company_name,
          :job_title,
          :ambassador_since_year,
        ],
      }
    end
  end
end
