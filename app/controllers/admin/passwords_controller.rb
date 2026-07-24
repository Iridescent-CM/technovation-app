# frozen_string_literal: true

module Admin
  class PasswordsController < AdminController
    skip_before_action :require_fresh_admin_password

    def new
      @account = current_account
    end

    def update
      if current_account.update(admin_password_params)
        SecurityEventLogger.log(
          event_type: "password.changed",
          account: current_account,
          actor: current_account,
          request: request
        )
        redirect_to admin_dashboard_path,
          success: t("controllers.admin.passwords.update.success")
      else
        @account = current_account
        render :new
      end
    end

    private

    def admin_password_params
      params.require(:account).permit(:password).tap do |permitted_params|
        permitted_params[:skip_existing_password] = true
      end
    end
  end
end
