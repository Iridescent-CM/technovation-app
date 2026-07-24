class AdminController < ApplicationController
  include Authenticated

  layout "admin"

  helper_method :current_admin

  before_action :require_current_admin
  before_action :reject_deactivated_admin
  before_action :require_completed_admin_password
  before_action :require_fresh_admin_password

  def current_user
    current_admin.account
  end

  def current_scope
    "admin"
  end

  private

  def require_current_admin
    return if current_admin.present?
    return redirect_to scoped_dashboard_path if impersonating?

    unauthorized!
  end

  def reject_deactivated_admin
    return unless current_account.deactivated?

    remove_cookie(CookieNames::AUTH_TOKEN)
    remove_cookie(CookieNames::SESSION_TOKEN)
    redirect_to login_path, alert: t("controllers.signins.create.deactivated")
  end

  def require_completed_admin_password
    return if current_account.full_admin? || current_account.not_admin?

    redirect_to admin_signup_path(token: current_account.admin_invitation_token),
      alert: "You need to create a secure password"
  end

  def require_fresh_admin_password
    return unless current_account.password_expired?

    redirect_to new_admin_password_path,
      alert: t("controllers.admin.passwords.new.alert")
  end

  def current_admin
    @current_admin ||= current_account.admin_profile
  end

  def current_profile
    current_admin
  end

  def current_profile_type
    "AdminProfile"
  end
end
