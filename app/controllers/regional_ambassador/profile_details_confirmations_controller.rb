module RegionalAmbassador
  class ProfileDetailsConfirmationsController < ApplicationController
    def create
      @regional_ambassador_profile = RegionalAmbassadorProfile.new(
        regional_ambassador_profile_params
      )

      if @regional_ambassador_profile.save
        remove_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
        ProfileCreating.execute(@regional_ambassador_profile, self)
      else
        render "regional_ambassador/signups/new"
      end
    end

    def update
      @regional_ambassador_profile = RegionalAmbassadorProfile.find(
        regional_ambassador_profile_params.fetch(:id)
      )

      if ProfileUpdating.execute(
          @regional_ambassador_profile,
          :regional_ambassador,
          regional_ambassador_profile_params
      )

        @regional_ambassador_profile.account.signup_attempt.registered!

        remove_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
        remove_cookie(CookieNames::SIGNUP_TOKEN)

        SignIn.(
          @regional_ambassador_profile.account,
          self,
          message: "Thank you! Welcome to Technovation!"
        )
      else
        render "regional_ambassador/signups/new"
      end
    end

    private
    def regional_ambassador_profile_params
      params.require(:regional_ambassador_profile).permit(
        :id,
        :organization_company_name,
        :ambassador_since_year,
        :job_title,
        :bio,
        account_attributes: [
          :id,
          :first_name,
          :last_name,
          :email,
          :date_of_birth,
          :gender,
          :password,
        ]
      ).tap do |tapped|
        tapped[:status] = :approved
        tapped[:account_attributes][:skip_existing_password] = true
        if action_name == "create"
          tapped[:account_attributes][:email] = UserInvitation.find_by!(
            admin_permission_token: get_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
          ).email
        end
      end
    end
  end
end
