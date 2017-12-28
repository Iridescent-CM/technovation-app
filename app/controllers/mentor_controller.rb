class MentorController < ApplicationController
  before_action :create_judge_mentor_on_dashboard
  include Authenticated

  layout "mentor"
  helper_method :current_mentor, :current_profile

  before_action -> {
    set_last_profile_used("mentor")
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
    @current_mentor ||= current_account.mentor_profile ||
      current_session.mentor_profile ||
        ::NullProfile.new
  end

  def current_profile
    current_mentor
  end

  def create_judge_mentor_on_dashboard
    # noop
    # implemented on mentor/dashboards controller
  end

  def require_current_team
    if current_mentor.teams.current.any?
      true
    else
      redirect_to mentor_dashboard_path,
        notice: t("controllers.application.team_required")
    end
  end

  def current_profile_type
    "MentorProfile"
  end
end
