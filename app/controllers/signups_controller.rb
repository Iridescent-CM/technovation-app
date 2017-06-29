class SignupsController < ApplicationController
  before_action :require_unauthenticated

  helper_method :admin_permission?, :signup_available?

  def new
    if not params[:admin_permission_token].blank? and (attempt = SignupAttempt.find_by(
        admin_permission_token: params[:admin_permission_token]
      ))
      cookies[:signup_token] = attempt.signup_token
      cookies[:admin_permission_token] = attempt.admin_permission_token
    end

    unless cookies[:signup_token].present?
      redirect_to root_path
    end
  end

  private
  def signup_available?(type)
    SeasonToggles.public_send("#{type}_signup?") or admin_permission?
  end

  def admin_permission?
    !!cookies[:admin_permission_token]
    # TODO: check token validity
  end
end
