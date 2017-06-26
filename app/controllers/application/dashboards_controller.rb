module Application
  class DashboardsController < ApplicationController
    layout -> { choose_layout_based_on_app_version }

    def show
      if ENV.fetch("APP_VERSION") { 2 }.to_i === 3
        render template: 'v3/application/dashboards/show'
      else
        if current_account.authenticated?
          last_profile_used = cookies.delete(:last_profile_used)

          path = cookies.delete(:redirected_from) ||
            (last_profile_used && public_send("#{last_profile_used}_dashboard_path")) ||
              send("#{current_account.type_name}_dashboard_path")

          redirect_to path
        else
          @signup_attempt = SignupAttempt.new(email: params[:email])
        end
      end
    end

    private
    def choose_layout_based_on_app_version
      if ENV.fetch("APP_VERSION") { 2 }.to_i === 3
        'v3/application'
      else
        'application'
      end
    end
  end
end
