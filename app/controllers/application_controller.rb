class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success

  layout :determine_layout
  helper_method :current_account, :current_team

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
    FindAccount.(cookies.fetch(:auth_token) { "" }).type_name
  end

  def require_unauthenticated
    account = FindAccount.(cookies.fetch(:auth_token) { "" })

    if account.authenticated?
      redirect_to send("#{account.type_name}_dashboard_path"),
        notice: t("controllers.application.already_authenticated")
    else
      true
    end
  end

  def current_account
    @current_account ||= FindAccount.(cookies.fetch(:auth_token) { "" })
  end

  def current_team
    current_account.team
  end
end
