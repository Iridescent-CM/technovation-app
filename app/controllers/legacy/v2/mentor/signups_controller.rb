module Legacy
  module V2
    module Mentor
      class SignupsController < ApplicationController
        before_action :require_unauthenticated

        def new
          @expertises ||= Expertise.all

          if token = cookies[:signup_token]
            email = SignupAttempt.find_by!(signup_token: token).email
            @mentor_profile = MentorProfile.new(account_attributes: { email: email })
          else
            redirect_to root_path
          end
        end

        def create
          @mentor_profile = MentorProfile.new(mentor_profile_params)

          if @mentor_profile.save
            cookies.delete(:signup_token)

            SignIn.(@mentor_profile.account,
                    self,
                    redirect_to: mentor_dashboard_path,
                    message: t("controllers.signups.create.success"))
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
  end
end
