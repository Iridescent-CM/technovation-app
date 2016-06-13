class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  private
  def authenticate_judge!
    if current_judge
      true
    else
      redirect_to signin_path, notice: t("controllers.application.unauthenticated")
    end
  end

  def current_judge
    @current_judge ||= Authentication.find_by(auth_token: cookies.fetch(:auth_token, ""))
  end
end
