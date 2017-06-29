class MentorController < ApplicationController
  before_action :create_judge_mentor_on_dashboard
  include Authenticated

  layout "mentor"
  helper_method :current_mentor

  before_action -> {
    if "mentor" != cookies[:last_profile_used]
      cookies[:last_profile_used] = "mentor"
    end
  }

  before_action -> {
    unless current_mentor.honor_code_signed?
      save_redirected_path
      redirect_to interruptions_path(issue: :honor_code)
    end
  }, unless: -> {
    %w{
      interruptions
      location_details
      profiles
      honor_code_agreements
      cookies
      dashboards
      background_checks
    }.include?(controller_name)
  }

  # For Airbrake Notifier
  def current_user
    current_mentor.account
  end

  def current_scope
    "mentor"
  end

  private
  def current_mentor
    @current_mentor ||= current_account.mentor_profile
  end

  def create_judge_mentor_on_dashboard
    # noop
    # implemented on mentor/dashboards controller
  end

  def require_current_team
    if current_team.present?
      true
    else
      redirect_to mentor_dashboard_path,
        notice: t("controllers.application.team_required")
    end
  end
end
