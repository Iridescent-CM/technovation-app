class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success
  add_flash_types :error

  helper_method :current_account,
    :current_team,
    :current_scope,
    :can_generate_certificate?

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

  def set_cookie(key, value)
    cookies[key] = value
  end

  def get_cookie(key)
    cookies.fetch(key) { false }
  end

  def remove_cookie(key)
    cookies.delete(key) or false
  end

  def current_account
    @current_account ||= Account.find_by(
      auth_token: cookies.fetch(:auth_token) { "" }
    ) || NullAuth.new
  end

  def current_team
    # TODO: Figure out how to clean up the
    # requirement of team_id in mentor scope
    case current_scope
    when "student"; current_account.team
    when "mentor"; current_account.teams.find(params.fetch(:team_id))
    end
  end

  private
  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def require_unauthenticated
    if current_account.authenticated?
      redirect_to send("#{current_account.scope_name}_dashboard_path"),
        notice: t("controllers.application.already_authenticated")
    else
      true
    end
  end

  def can_generate_certificate?(scope, cert_type)
    @can_generate_certificate ||= {}

    @can_generate_certificate[cert_type] ||= (
      ENV.fetch("CERTIFICATES") { false } and
        CheckIfCertificateIsAllowed.(
          send("current_#{scope}"),
          cert_type
        )
    )
  end

  def setup_valid_profile_from_signup_attempt(scope, token)
    email = SignupAttempt.find_by!(signup_token: token).email

    @profile = instance_variable_set(
      "@#{scope}_profile",
      "#{scope}_profile".camelize.constantize.new(
        account_attributes: { email: email }
      )
    )

    @profile.valid?

    if @profile.errors[:"account.email"]
      .include?("has already been taken")
      render "signups/email_taken" and return
    end

    @profile.errors.clear
    @profile.account.errors.clear
  end

  def current_scope; raise NotImplementedError; end
end
