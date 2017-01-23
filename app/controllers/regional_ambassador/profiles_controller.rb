module RegionalAmbassador
  class ProfilesController < RegionalAmbassadorController
    include ProfileController

    def index
      params[:season] ||= Season.current.year
      params[:type] ||= "All"
      params[:per_page] = 25 if params[:per_page].blank?
      params[:page] = 1 if params[:page].blank?

      params[:team_status] = "All" if params[:team_status].blank?
      params[:parental_consent_status] = "All" if params[:parental_consent_status].blank?
      params[:cleared_status] = "All" if params[:cleared_status].blank?

      @accounts = RegionalAccount.(current_ambassador, params)
        .paginate(per_page: params[:per_page], page: params[:page])
    end

    def profile_params
      [
        :organization_company_name,
        :job_title,
        :ambassador_since_year,
        :bio,
      ]
    end

    private
    def account
      current_ambassador
    end

    def edit_profile_path
      edit_regional_ambassador_profile_path
    end

    def account_param_root
      :regional_ambassador_profile
    end
  end
end
