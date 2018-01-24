class MentorController < ApplicationController
  before_action :create_judge_mentor_on_dashboard
  include Authenticated

  layout "mentor"
  helper_method :current_mentor, :current_profile, :current_team

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

  def current_team
    if id = params&.dig(:team_submission, :id)
      @current_team ||= current_mentor.teams
        .joins(:submission)
        .where("team_submissions.id = ?", id)
        .first ||
          raise(
            ActiveRecord::RecordNotFound,
            "team not found with submission id: #{id}"
          )
    elsif friendly_id = params[:id]
      submission = @team_submission ||
        TeamSubmission.friendly.find(friendly_id)

      @current_team ||= current_mentor.teams
        .joins(:submission)
        .where("team_submissions.id = ?", submission.id)
        .first ||
          raise(
            ActiveRecord::RecordNotFound,
            "team not found with submission id: #{submission.id}"
          )
    elsif team_id = params.fetch(:team_id)
      @current_team ||= current_mentor.teams.find(team_id)
    else
      raise(KeyError, "missing key for team_submission[id]")
    end
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
