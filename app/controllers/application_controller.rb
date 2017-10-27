class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success
  add_flash_types :error

  helper_method :current_account,
    :current_team,
    :current_scope,
    :current_session,
    :can_generate_certificate?,
    :get_cookie,
    :regional_ambassador

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

  def set_cookie(key, value, passed_options  = {})
    default_options = {
      permanent: false,
    }

    options = default_options.merge(passed_options)

    if options[:permanent]
      cookies.permanent.signed[key] = value
    else
      cookies.signed[key] = value
    end
  end

  def get_cookie(key)
    cookies.signed[key] || false
  end

  def remove_cookie(key)
    value = get_cookie(key)
    set_cookie(key, nil)
    value
  end

  def current_account
    @current_account ||= Account.find_by(
      auth_token: get_cookie(:auth_token)
    ) || NullAuth.new
  end

  def current_session
    @current_session ||= Account.find_by(
      session_token: get_cookie(:session_token)
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
  def regional_ambassador
    @regional_ambassador ||= RegionalAmbassadorProfile.approved
      .joins(:current_account)
      .find_by({ "accounts.country" => current_account.country }.merge(
        current_account.country == "US" ?
          { "accounts.state_province" => current_account.state_province } : {}
      )) || NullRegionalAmbassador.new
  end

  def save_redirected_path
    set_cookie(:redirected_from, request.fullpath)
  end

  def require_unauthenticated
    if current_account.authenticated?
      redirect_to send("#{current_account.scope_name}_dashboard_path"),
        notice: t("controllers.application.already_authenticated")
    else
      true
    end
  end

  def force_logout
    remove_cookie(:auth_token)
    remove_cookie(:session_token)
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

    if account = Account.find_by(email: email) and
        account.regional_ambassador_profile.present?
      @regional_ambassador_profile = account.regional_ambassador_profile
    else
      @profile = instance_variable_set(
        "@#{scope}_profile",
        "#{scope}_profile".camelize.constantize.new(
          account_attributes: { email: email }
        )
      )

      if not @profile.valid? and
          @profile.errors[:"account.email"].include?("has already been taken")
        render "signups/email_taken",
          locals: {
            email: @profile.email
          } and return
      else
        @profile.errors.clear
        @profile.account.errors.clear
      end
    end
  end

  def set_last_profile_used(scope)
    return if current_session.authenticated?

    if scope != get_cookie(:last_profile_used)
      set_cookie(:last_profile_used, scope)
    end
  end

  def current_scope; raise NotImplementedError; end
end
