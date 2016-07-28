class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  layout :determine_layout

  def set_cookie(key, value)
    cookies[key] = value
  end

  def get_cookie(key)
    cookies.fetch(key) { false }
  end

  def remove_cookie(key)
    cookies.delete(key) or false
  end

  private
  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def go_to_signin(profile)
    redirect_to signin_path, notice: t("controllers.application.unauthenticated",
                                       profile: profile.indefinitize.humanize.downcase)
  end

  def determine_layout
    Account.find_with_token(cookies.fetch(:auth_token) { "" }).type_name
  end
end
