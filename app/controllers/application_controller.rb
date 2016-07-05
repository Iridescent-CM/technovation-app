class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  helper_method :authenticated?, :admin?

  private
  def authenticated?
    FindAccount.authenticated?(cookies)
  end

  def admin?
    FindAccount.current(:admin, cookies).authenticated?
  end

  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def go_to_signin(profile)
    redirect_to signin_path, notice: t("controllers.application.unauthenticated",
                                       profile: profile.indefinitize)
  end

  def sign_in(signin, options = {})
    signin_options = { message: t('controllers.signins.create.success'),
                       redirect: after_signin_path }.merge(options)
    cookies[:auth_token] = signin.auth_token
    redirect_to signin_options[:redirect], success: signin_options[:message]
  end

  def after_signin_path
    cookies.delete(:redirected_from) or root_path
  end
end
