class ApplicationController < ActionController::Base
  include Pundit::Authorization

  include CookiesHelper
  include ForceTermsAgreement
  include ForceLocation

  protect_from_forgery with: :exception

  add_flash_types :success
  add_flash_types :error

  helper_method :current_account,
    :current_scope,
    :current_profile,
    :current_profile_type,
    :current_session,
    :get_cookie,
    :chapter_ambassador

  rescue_from "ActionController::ParameterMissing" do |e|
    if e.message.include?("token")
      redirect_to token_error_path
    else
      raise e
    end
  end

  rescue_from "Rack::Timeout::RequestTimeoutException" do |e|
    redirect_to timeout_error_path(back: request.fullpath)
  end

  def current_account
    auth_token = get_cookie(CookieNames::AUTH_TOKEN)

    return current_session if current_session.authenticated?

    if !!auth_token
      @current_account ||= Account.find_by(auth_token: auth_token) || ::NullAuth.new
    else
      ::NullAuth.new
    end
  end

  def pundit_user
    current_account
  end

  def current_session
    return @current_session if defined?(@current_session)

    session_token = get_cookie(CookieNames::SESSION_TOKEN)

    if !!session_token
      @current_session = Account.find_by(
        session_token: get_cookie(CookieNames::SESSION_TOKEN)
      ) || ::NullAuth.new
    else
      @current_session = ::NullAuth.new
    end
  end

  private
  def region_account
    if current_session.authenticated?
      current_session
    else
      current_account
    end
  end

  def chapter_ambassador
    return @chapter_ambassador if defined?(@chapter_ambassador)

    @chapter_ambassador = region_account.chapter_ambassador
  end

  def save_redirected_path
    set_cookie(CookieNames::REDIRECTED_FROM, request.fullpath)
  end

  def require_unauthenticated
    if current_account.authenticated?
      redirect_to send("#{current_account.scope_name}_dashboard_path"),
        notice: t("controllers.application.already_authenticated")
    else
      true
    end
  end

  def require_signup_enabled
    SeasonToggles.registration_open? ||
      redirect_to(root_path, alert: "Signup is not open right now")
  end

  def force_logout
    remove_cookie(CookieNames::AUTH_TOKEN)
    remove_cookie(CookieNames::SESSION_TOKEN)
  end

  def setup_valid_profile_from_invitation(scope, *args)
    if args.length > 1
      invite = args[0]
      token = args[1]
    else
      token = args[0]
    end

    invite ||= UserInvitation.find_by(admin_permission_token: token) ||
      GlobalInvitation.active.find_by!(token: token)

    invite.opened!

    @profile = instance_variable_set(
      "@#{scope}_profile",
      "#{scope}_profile".camelize.constantize.new(
        account_attributes: { email: invite.email },
      )
    )

    remove_cookie(CookieNames::AUTH_TOKEN)
    GlobalInvitation.set_if_exists(@profile, token)
    set_cookie(*invite.to_cookie_params)
  end

  def set_last_profile_used(scope)
    return if current_session.authenticated?

    if scope != get_cookie(CookieNames::LAST_PROFILE_USED)
      set_cookie(CookieNames::LAST_PROFILE_USED, scope)
    end
  end

  def current_profile
    ::NullProfile.new
  end

  def current_scope
    "NO_SCOPE_DEFINED_HERE"
  end

  def current_profile_type
    "NO_PROFILE_TYPE_DEFINED_HERE"
  end
end
