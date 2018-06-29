class SignupsController < ApplicationController
  before_action :require_unauthenticated

  helper_method :admin_permission?, :signup_available?

  def new
    if not params[:admin_permission_token].blank? and
        (attempt = SignupAttempt.find_by(
          admin_permission_token: params[:admin_permission_token]
        ))
      set_cookie(CookieNames::SIGNUP_TOKEN, attempt.signup_token)
      set_cookie(CookieNames::ADMIN_PERMISSION_TOKEN, attempt.admin_permission_token)
    end

    if attempt.present? and
        attempt.account.present? and
          attempt.account.regional_ambassador_profile.present?
      redirect_to regional_ambassador_signup_path
    elsif not !!get_cookie(CookieNames::SIGNUP_TOKEN)
      redirect_to root_path
    end
  end

  private
  def signup_available?(type)
    SeasonToggles.public_send("#{type}_signup?") or admin_permission?
  end

  def admin_permission?
    !!get_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
    # TODO: check token validity
  end
end
