module RegionalAmbassador
  class ProfilesController < RegionalAmbassadorController
    include ProfileController

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
