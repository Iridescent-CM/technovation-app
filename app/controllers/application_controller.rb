class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success
  add_flash_types :error

  helper_method :current_account,
    :current_scope,
    :current_profile,
    :current_profile_type,
    :current_session,
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

  before_action -> {
    StoreLocation.(
      ip_address: request.remote_ip,
      context: self,
      account: current_account,
    )
  }

  def set_cookie(key, value, passed_options  = {})
    default_options = {
      permanent: false,
    }

    options = default_options.merge(passed_options)

    if options[:permanent]
      cookies.permanent.signed[key] = {
        value: value,
        domain: ENV.fetch("COOKIE_DOMAIN"),
      }
    else
      cookies.signed[key] = {
        value: value,
        domain: ENV.fetch("COOKIE_DOMAIN"),
      }
    end
  end

  def get_cookie(key)
    cookies.signed[key] || false
  end

  def remove_cookie(key)
    value = get_cookie(key)
    cookies.delete(key, domain: ENV.fetch("COOKIE_DOMAIN"))
    value
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
  def regional_ambassador
    return @regional_ambassador if defined?(@regional_ambassador)

    region_account = if current_session.authenticated?
                       current_session
                     else
                       current_account
                     end

    intnl_find_by = {
      "accounts.country" => region_account.country
    }

    find_by = intnl_find_by.merge({
      "accounts.state_province" => region_account.state_province
    })

    @regional_ambassador = RegionalAmbassadorProfile.not_staff
      .approved
      .joins(:current_account)
      .where("intro_summary NOT IN ('') AND intro_summary IS NOT NULL")
      .find_by(find_by) || ::NullRegionalAmbassador.new

    if @regional_ambassador.present?
      @regional_ambassador
    elsif region_account.country != "US" and
            not region_account.address_details.blank?

      if account = Account.current
        .joins(:approved_regional_ambassador_profile)
        .where.not("accounts.email ILIKE ?", "%joesak%")
        .where(
          "regional_ambassador_profiles.intro_summary NOT IN ('')
          AND regional_ambassador_profiles.intro_summary IS NOT NULL"
        )
        .where(intnl_find_by)
        .near(
          region_account.address_details,
          SearchMentors::EARTH_CIRCUMFERENCE
        )
        .first

        @regional_ambassador = account.regional_ambassador_profile
      else
        @regional_ambassador = ::NullRegionalAmbassador.new
      end

    elsif region_account.country != "US"
      @regional_ambassador = RegionalAmbassadorProfile.not_staff
        .approved
        .joins(:current_account)
        .where("intro_summary NOT IN ('') AND intro_summary IS NOT NULL")
        .find_by(intnl_find_by) || ::NullRegionalAmbassador.new
    else
      @regional_ambassador
    end
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

  def force_logout
    remove_cookie(CookieNames::AUTH_TOKEN)
    remove_cookie(CookieNames::SESSION_TOKEN)
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
          @profile.errors[:"account.email"].include?(
            "has already been taken"
          )
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
