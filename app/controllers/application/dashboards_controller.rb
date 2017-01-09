module Application
  class DashboardsController < ApplicationController
    def show
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
end
