class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  helper_method :authenticated?, :admin?, :judge?, :student?

  private
  def authenticated?
    FindAuthenticationRole.authenticated?(cookies)
  end

  Account::PROFILE_TYPES.each do |role_name|
    define_method "#{role_name}?" do
      FindAuthenticationRole.current(role_name, cookies).authenticated?
    end
  end

  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def go_to_signin
    redirect_to signin_path, notice: t("controllers.application.unauthenticated")
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
