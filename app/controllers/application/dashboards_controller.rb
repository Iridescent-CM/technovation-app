module Application
  class DashboardsController < ApplicationController
    def show
      if current_account.authenticated?
        redirect_to(
          cookies.delete(:redirected_from) ||
            last_used_scope_dashboard_path ||
              user_scope_dashbaord_path
        )
      else
        @signup_attempt = SignupAttempt.new(email: params[:email])
      end
    end

    private
    def last_used_scope_dashboard_path
      last_scope_used = cookies.delete(:last_profile_used)
      !!last_scope_used && public_send("#{last_scope_used}_dashboard_path")
    end

    def user_scope_dashbaord_path
      public_send("#{current_account.scope_name}_dashboard_path")
    end
  end
end
