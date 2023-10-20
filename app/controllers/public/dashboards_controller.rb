module Public
  class DashboardsController < ApplicationController
    include LocationStorageController
    layout "application_rebrand"

    def show
      if current_account.authenticated?
        redirect_to(
          remove_cookie(CookieNames::REDIRECTED_FROM) ||
            last_used_scope_dashboard_path ||
              user_scope_dashbaord_path
        )
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
