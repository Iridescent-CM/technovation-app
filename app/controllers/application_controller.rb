class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  helper_method :authenticated?, :admin?, :judge?, :student?

  private
  def authenticated?
    FindAuthenticationRole.authenticated?(cookies)
  end

  def admin?
    FindAuthenticationRole.current(:admin, cookies).authenticated?
  end

  def judge?
    FindAuthenticationRole.current(:judge, cookies).authenticated?
  end

  def student?
    FindAuthenticationRole.current(:student, cookies).authenticated?
  end

  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def go_to_signin(profile)
    redirect_to signin_path, notice: t("controllers.application.unauthenticated",
                                       profile: profile.indefinitize)
  end

  def sign_in(signin, success_msg = t('controllers.signins.create.success'))
    cookies[:auth_token] = signin.auth_token

    redirect_to after_signin_path, success: success_msg
  end

  def after_signin_path
    cookies.delete(:redirected_from) or
      send("#{profile_type}_dashboard_path") or
        root_path
  end

  def profile_type
    "application"
  end
end
