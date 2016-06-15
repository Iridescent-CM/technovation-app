class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  helper_method :authenticated?, :admin?

  private
  def authenticated?
    FindAuthenticationRole.authenticated?(cookies)
  end

  def admin?
    FindAuthenticationRole.current(:admin, cookies).authenticated?
  end

  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def go_to_signin
    redirect_to signin_path, notice: t("controllers.application.unauthenticated")
  end

  def sign_in(signin, success_msg = t('controllers.signins.create.success'))
    cookies[:auth_token] = signin.auth_token

    redirect_to cookies.delete(:redirected_from) || root_path,
                success: success_msg
  end
end
