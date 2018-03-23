module Judge
  class DashboardsController < JudgeController
    def show
      @regional_events = RegionalPitchEvent.available_to(current_judge)
      @score_in_progress = ScoreInProgress.new(current_judge)
    end

    private
    def create_mentor_judge_on_dashboard
      return if current_session.authenticated?
        # RA/Admin Logged in as someone else

      if CreateJudgeProfile.(current_account)
        flash.now[:success] = t(
          "controllers.judge.dashboards.show.judge_profile_created"
        )
      end
    end
  end
end
