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
