module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    include AccountController

    def index
      @accounts = Account.includes(:seasons).references(:seasons).where("seasons.year = ?", Season.current.year)

      @accounts = if current_ambassador.country == "US"
        @accounts.where(state_province: current_ambassador.state_province)
      else
        @accounts.where(country: current_ambassador.country)
      end

      @accounts = @accounts.paginate(per_page: 25, page: params[:page])
    end

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
          :background_check_completed_at,
          :bio,
        ],
      }
    end
  end
end
