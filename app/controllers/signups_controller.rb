class SignupsController < ApplicationController
  before_action :require_unauthenticated

  helper_method :no_admin_permission?

  def new
    if attempt = SignupAttempt.find_by(
        admin_permission_token: params[:admin_permission_token]
      )
      cookies[:signup_token] = attempt.signup_token
      cookies[:admin_permission_token] = attempt.admin_permission_token
    end

    unless cookies[:signup_token].present?
      redirect_to root_path
    end
  end

  private
  def no_admin_permission?
    token = cookies.fetch(:admin_permission_token) { "" }
    token.blank?
  end
end
