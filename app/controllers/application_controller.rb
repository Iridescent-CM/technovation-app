class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  helper_method :authenticated?

  private
  def authenticated?
    current_judge.authenticated?
  end

  def authenticate_judge!
    authenticated? || (save_redirected_path && go_to_signin)
  end

  def current_judge
    @current_judge ||= Authentication.find_by(auth_token: cookies.fetch(:auth_token, "")).user
  end

  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def go_to_signin
    redirect_to signin_path, notice: t("controllers.application.unauthenticated")
  end

  def sign_in(signin)
    cookies[:auth_token] = signin.auth_token
    redirect_to cookies.delete(:redirected_from) || root_path,
                success: t('controllers.signins.create.success')
  end
end
