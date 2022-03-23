module Judge
  class SignupsController < ApplicationController
    def new
      signup_token = get_cookie(CookieNames::SIGNUP_TOKEN)

      invite_token = params[:admin_permission_token] ||
        params[:invitation]

      invite = UserInvitation.find_by(
        admin_permission_token: invite_token
      )

      if !!invite_token && !!invite && invite.registered?
        SignIn.(invite.account, self, permanent: true)
      elsif !!invite_token || !!signup_token
        redirect_to signup_path
      else
        redirect_to root_path
      end
    end

    def create
      @judge_profile = JudgeProfile.new(judge_profile_params)

      if @judge_profile.save
        ProfileCreating.execute(@judge_profile, self, :judge)
      else
        GlobalInvitation.set_if_exists(
          @judge_profile,
          get_cookie(CookieNames::GLOBAL_INVITATION_TOKEN)
        )
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
        attempt = GlobalInvitation.find_by(
          token: get_cookie(CookieNames::GLOBAL_INVITATION_TOKEN)
        ) ||
          SignupAttempt.find_by(
            signup_token: get_cookie(CookieNames::SIGNUP_TOKEN)
          ) ||
            UserInvitation.find_by(
              admin_permission_token: get_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
            )

        tapped[:account_attributes][:email] ||= attempt.email

        unless attempt.is_a?(GlobalInvitation) or
            attempt.temporary_password?
          tapped[:account_attributes][:password_digest] =
            attempt.password_digest
        end
      end
    end
  end
end
