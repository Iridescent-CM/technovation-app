class JudgeController < ApplicationController
  before_action :create_mentor_judge_on_dashboard
  include Authenticated

  layout "judge"
  helper_method :current_judge,
                :assigned_teams,
                :current_round,
                :quarterfinals?

  before_action -> {
    if "judge" != cookies[:last_profile_used]
      cookies[:last_profile_used] = "judge"
    end
  }

  # For Airbrake Notifier
  def current_user
    current_account
  end

  private
  def current_judge
    @current_judge ||= current_account.judge_profile
  end

  def model_name
    "judge"
  end

  def create_mentor_judge_on_dashboard
    # Implemented in Judge::DashboardsController
  end

  def assigned_teams(judge)
    if judge.assigned_teams.empty?
      judge.selected_regional_pitch_event.teams
    else
      judge.assigned_teams
    end
  end

  def current_round
    case ENV.fetch("JUDGING_ROUND") { "QF" }
    when "QF"
      :quarterfinals
    when "SF"
      :semifinals
    end
  end

  def quarterfinals?
    current_round == :quarterfinals
  end
end
