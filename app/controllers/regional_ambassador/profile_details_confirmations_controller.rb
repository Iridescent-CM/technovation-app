module RegionalAmbassador
  class ProfileDetailsConfirmationsController < ApplicationController
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
        tapped[:account_attributes][:skip_existing_password] = true
      end
    end
  end
end
