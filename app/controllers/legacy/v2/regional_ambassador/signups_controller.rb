module Legacy
  module V2
    module RegionalAmbassador
      class SignupsController < ApplicationController
        before_action :require_unauthenticated

        def new
          if token = cookies[:signup_token]
            email = SignupAttempt.find_by!(signup_token: token).email
            @regional_ambassador_profile = RegionalAmbassadorProfile.new(
              account_attributes: { email: email }
            )
          else
            redirect_to root_path
          end
        end

        def create
          @regional_ambassador_profile = RegionalAmbassadorProfile.new(
            regional_ambassador_profile_params
          )

          if @regional_ambassador_profile.save
            AdminMailer.pending_regional_ambassador(@regional_ambassador_profile.account).deliver_later

            cookies.delete(:signup_token)

            SignIn.(@regional_ambassador_profile.account,
                    self,
                    redirect_to: regional_ambassador_dashboard_path,
                    message: t("controllers.signups.create.success"))
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
  end
end
