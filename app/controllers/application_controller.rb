class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  layout :determine_layout

  def set_cookie(key, value)
    cookies[key] = value
  end

  def after_signin_path
    cookies.delete(:redirected_from) or root_path
  end

  private
  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def go_to_signin(profile)
    redirect_to signin_path, notice: t("controllers.application.unauthenticated",
                                       profile: profile.indefinitize)
  end

  def determine_layout
    DetermineLayout.(cookies.fetch(:auth_token) { "" })
  end
end
