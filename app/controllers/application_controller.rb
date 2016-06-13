class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  helper_method :authenticated?

  private
  def authenticated?
    !!current_judge
  end

  def authenticate_judge!
    authenticated? ||
      redirect_to(signin_path, notice: t("controllers.application.unauthenticated"))
  end

  def current_judge
    @current_judge ||= Authentication.find_by(auth_token: cookies.fetch(:auth_token, ""))
  end
end
