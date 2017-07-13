class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success
  add_flash_types :error

  helper_method :current_account, :current_team, :can_generate_certificate?

  before_action -> {
    I18n.locale = current_account.locale
  }

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

  private
  def save_redirected_path
    cookies[:redirected_from] = request.fullpath
  end

  def require_unauthenticated
    if current_account.authenticated?
      redirect_to send("#{current_account.type_name}_dashboard_path"),
        notice: t("controllers.application.already_authenticated")
    else
      true
    end
  end

  def current_account
    @current_account ||= Account.eager_load(
      :regional_ambassador_profile,

      mentor_profile: [
        :team_member_invites,
        teams: [
          :team_submissions,
          :division,
          regional_pitch_events: :regional_ambassador_profile,
        ],
      ],

      judge_profile: [
        :submission_scores,
        regional_pitch_events: :regional_ambassador_profile,
      ],

      student_profile: [
        :team_member_invites,
        teams: [
          :team_submissions,
          :division,
          regional_pitch_events: :regional_ambassador_profile,
        ],
      ],

      season_registrations: :season
    ).find_by(auth_token: cookies.fetch(:auth_token) { "" }) || NullAuth.new
  end

  def current_team
    case model_name
    when "student"; current_account.team
    when "mentor"; current_account.teams.find(params.fetch(:team_id))
    end
  end

  def can_generate_certificate?(user_scope, cert_type)
    @can_generate_certificate ||= {}

    @can_generate_certificate[cert_type] ||= (
      ENV.fetch("CERTIFICATES") { false } and
        CheckIfCertificateIsAllowed.(
          send("current_#{user_scope}"),
          cert_type
        )
    )
  end

  def model_name; end
end
