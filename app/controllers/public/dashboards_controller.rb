module Public
  class DashboardsController < ApplicationController
    include LocationStorageController

    def show
      token = get_cookie(CookieNames::SIGNUP_TOKEN)

      if current_account.authenticated?
        redirect_to(
          remove_cookie(CookieNames::REDIRECTED_FROM) ||
            last_used_scope_dashboard_path ||
              user_scope_dashbaord_path
        )
      elsif token
        @signup_attempt = SignupAttempt.wizard.find_by(wizard_token: token)

        if !@signup_attempt.country_code

          if result = Geocoder.search(
              get_cookie(CookieNames::IP_GEOLOCATION)['coordinates'],
              lookup: :google
            ).first

            geocoded = Geocoded.new(result)
            @signup_attempt.update({
              city: geocoded.city,
              state_code: geocoded.state_code,
              country_code: geocoded.country_code,
              latitude: geocoded.latitude,
              longitude: geocoded.longitude,
            })

          end

        end

      end
    end

    private
    def last_used_scope_dashboard_path
      last_scope_used = remove_cookie(CookieNames::LAST_PROFILE_USED)
      !!last_scope_used && public_send("#{last_scope_used}_dashboard_path")
    end

    def user_scope_dashbaord_path
      public_send("#{current_account.scope_name}_dashboard_path")
    end
  end
end
