class JudgeController < ApplicationController
  include Authenticated

  layout "judge"
  helper_method :current_judge,
    :current_profile,
    :assigned_teams,
    :current_round,
    :quarterfinals?,
    :back_from_event_path

  before_action -> {
    set_last_profile_used("judge")
  }

  # For Airbrake Notifier
  def current_user
    current_account
  end

  def current_scope
    "judge"
  end

  private
  def current_judge
    @current_judge ||= current_account.judge_profile ||
      current_session.judge_profile
  end

  def current_profile
    current_judge
  end

  def back_from_event_path
    judge_dashboard_path
  end

  def assigned_teams(judge)
    if judge.assigned_teams.empty?
      judge.selected_regional_pitch_event.teams
    else
      judge.assigned_teams
    end
  end

  def current_round
    case SeasonToggles.judging_round
    when "qf"
      :quarterfinals
    when "sf"
      :semifinals
    end
  end

  def quarterfinals?
    SeasonToggles.quarterfinals?
  end

  def current_profile_type
    "JudgeProfile"
  end

  def require_onboarded
    unless current_judge.onboarded?
      redirect_to judge_dashboard_path,
        error: "You need to finish your onboarding to judge scores"
    end
  end
end
