module RegionalAmbassador
  class SignupsController < ApplicationController
    before_action :require_unauthenticated

    def new
      if token = cookies[:signup_token]
        setup_valid_profile_from_signup_attempt(:regional_ambassador, token)
      else
        redirect_to root_path
      end
    end

    def create
      @regional_ambassador_profile = RegionalAmbassadorProfile.new(
        regional_ambassador_profile_params
      )

      if @regional_ambassador_profile.save
        ProfileCreating.execute(@regional_ambassador_profile, self)
      else
        render :new
      end
    end

    private
    def regional_ambassador_profile_params
      params.require(:regional_ambassador_profile).permit(
        :ambassador_since_year,
        :organization_company_name,
        :bio,
        :job_title,
        account_attributes: [
          :id,
          :email,
          :password,
          :date_of_birth,
          :first_name,
          :last_name,
          :gender,
          :geocoded,
          :city,
          :state_province,
          :country,
          :latitude,
          :longitude,
          :referred_by,
          :referred_by_other,
        ],
      ).tap do |tapped|
        attempt = SignupAttempt.find_by!(signup_token: cookies.fetch(:signup_token))
        tapped[:account_attributes][:email] = attempt.email

        unless attempt.temporary_password?
          tapped[:account_attributes][:password_digest] = attempt.password_digest
        end
      end
    end
  end
end
