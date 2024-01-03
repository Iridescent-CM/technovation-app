module Admin
  class SignupsController < ApplicationController
    layout "admin"

    def new
      @account = Account.temporary_password.find_by(admin_invitation_token: params.fetch(:token))

      if !@account
        redirect_to root_path,
          alert: "You are not allowed to be there" and return
      else
        remove_cookie(CookieNames::AUTH_TOKEN)
        set_cookie(CookieNames::AUTH_TOKEN, @account.auth_token)
      end
    end

    def update
      if current_account.not_admin?
        redirect_to root_path, alert: "You are not allowed to be there!" and return
      end

      if current_account.update(admin_password_params)
        current_account.full_admin!
        current_account.regenerate_admin_invitation_token
        redirect_to admin_dashboard_path, success: "Welcome to Technovation Admin"
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
