module ChapterAmbassador
  class SignupsController < ApplicationController
    def new
      signup_token = get_cookie(CookieNames::SIGNUP_TOKEN)

      invite_token = params[:admin_permission_token]
      invite = UserInvitation.find_by(admin_permission_token: invite_token)

      if !!signup_token
        setup_valid_profile_from_signup_attempt(:chapter_ambassador, signup_token)
      elsif !!invite_token && !!invite && invite.registered?
        SignIn.(invite.account, self, permanent: true)
      elsif !!invite_token
        setup_valid_profile_from_invitation(:chapter_ambassador, invite_token)
        flash.now[:success] = "Thank you for confirming your email address."
      else
        redirect_to root_path
      end
    end

    def create
      @chapter_ambassador_profile = ChapterAmbassadorProfile.new(
        chapter_ambassador_profile_params
      )

      if @chapter_ambassador_profile.save
        ProfileCreating.execute(@chapter_ambassador_profile, self)
      else
        render :new
      end
    end

    private
    def chapter_ambassador_profile_params
      params.require(:chapter_ambassador_profile).permit(
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
        attempt = SignupAttempt.find_by!(signup_token: get_cookie(CookieNames::SIGNUP_TOKEN))
        tapped[:account_attributes][:email] = attempt.email

        unless attempt.temporary_password?
          tapped[:account_attributes][:password_digest] = attempt.password_digest
        end
      end
    end
  end
end
