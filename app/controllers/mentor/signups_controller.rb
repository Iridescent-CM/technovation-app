module Mentor
  class SignupsController < ApplicationController
    def new
      @expertises ||= Expertise.all
      @mentor_types ||= MentorType.all

      signup_token = get_cookie(CookieNames::SIGNUP_TOKEN)

      invite_token = params[:admin_permission_token]
      invite = UserInvitation.find_by(admin_permission_token: invite_token)

      if !!signup_token
        setup_valid_profile_from_signup_attempt(:mentor, signup_token)
      elsif !!invite_token && !!invite && invite.registered?
        SignIn.(invite.account, self, permanent: true)
      elsif !!invite_token
        setup_valid_profile_from_invitation(:mentor, invite_token)
      else
        redirect_to root_path
      end
    end

    def create
      @mentor_profile = MentorProfile.new(mentor_profile_params)

      if @mentor_profile.save
        ProfileCreating.execute(@mentor_profile, self)
      else
        @expertises ||= Expertise.all
        render :new
      end
    end

    private
    def mentor_profile_params
      params.require(:mentor_profile).permit(
        :bio,
        :job_title,
        :school_company_name,
        expertise_ids: [],
        mentor_type_ids: [],
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
        attempt = SignupAttempt.find_by(
          signup_token: get_cookie(CookieNames::SIGNUP_TOKEN)
        ) || UserInvitation.find_by!(
          admin_permission_token: get_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
        )

        tapped[:account_attributes][:email] = attempt.email

        unless attempt.temporary_password?
          tapped[:account_attributes][:password_digest] = attempt.password_digest
        end
      end
    end
  end
end
