module Student
  class SignupsController < ApplicationController
    before_action :require_unauthenticated

    before_action -> {
      attempt = (
        SignupAttempt.pending | SignupAttempt.temporary_password
      ).detect { |a| a.activation_token == params[:token] }

      if !!attempt and attempt.pending?
        attempt.active!
      elsif !!attempt and attempt.temporary_password?
        attempt.regenerate_signup_token
      end

      if !!attempt
        cookies[:signup_token] = attempt.signup_token
      end
    }, only: :new

    def new
      if token = cookies[:signup_token]
        setup_valid_profile_from_signup_attempt(:student, token)
      else
        redirect_to root_path
      end
    end

    def create
      @student_profile = StudentProfile.new(student_profile_params)

      if @student_profile.save
        ProfileCreating.execute(@student_profile, self)
      else
        render :new
      end
    end

    private
    def student_profile_params
      params.require(:student_profile).permit(
        :school_name,
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
        attempt = SignupAttempt.find_by!(
          signup_token: cookies.fetch(:signup_token)
        )

        tapped[:account_attributes][:email] = attempt.email

        unless attempt.temporary_password?
          tapped[:account_attributes][:password_digest] =
            attempt.password_digest
        end
      end
    end
  end
end
