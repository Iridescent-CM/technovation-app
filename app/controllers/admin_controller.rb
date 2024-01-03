class AdminController < ApplicationController
  include Authenticated

  layout "admin"

  helper_method :current_admin

  before_action -> {
    if !current_account.full_admin? && !current_account.not_admin?
      redirect_to admin_signup_path(token: current_account.admin_invitation_token),
        alert: "You need to create a secure password" and return
    end

    params.permit!
  }

  def current_user
    current_admin.account
  end

  def current_scope
    "admin"
  end

  private

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
