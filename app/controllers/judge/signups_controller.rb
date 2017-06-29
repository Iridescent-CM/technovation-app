module Judge
  class SignupsController < ApplicationController
    before_action :require_unauthenticated

    def new
      if token = cookies[:signup_token]
        setup_valid_profile_from_signup_attempt(:judge, token)
      else
        redirect_to root_path
      end
    end

    def create
      @judge_profile = JudgeProfile.new(judge_profile_params)

      if @judge_profile.save
        ProfileCreating.execute(@judge_profile, self, :judge)
      else
        render :new
      end
    end

    private
    def judge_profile_params
      params.require(:judge_profile).permit(
        :company_name,
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
