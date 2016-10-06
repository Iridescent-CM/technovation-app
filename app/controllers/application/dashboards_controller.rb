module Application
  class DashboardsController < ApplicationController
    def show
      if current_account.authenticated?
        redirect_to send("#{current_account.type_name}_dashboard_path")
      end
    end
  end
end
