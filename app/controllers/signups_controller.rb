class SignupsController < ApplicationController
  before_action :require_unauthenticated

  helper_method :admin_permission?, :signup_available?

  def new
    if not params[:admin_permission_token].blank? and
        (attempt = SignupAttempt.find_by(
          admin_permission_token: params[:admin_permission_token]
        ))
      set_cookie(:signup_token, attempt.signup_token)
      set_cookie(:admin_permission_token, attempt.admin_permission_token)
    end

    if attempt.present? and
        attempt.account.present? and
          attempt.account.regional_ambassador_profile.present?
      redirect_to regional_ambassador_signup_path
    elsif not !!get_cookie(:signup_token)
      redirect_to root_path
    end
  end

  private
  def signup_available?(type)
    SeasonToggles.public_send("#{type}_signup?") or admin_permission?
  end

  def admin_permission?
    !!get_cookie(:admin_permission_token)
    # TODO: check token validity
  end
end
