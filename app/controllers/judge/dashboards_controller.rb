module Judge
  class DashboardsController < JudgeController
    include LocationStorageController

    def show
      @regional_events = RegionalPitchEvent.available_to(current_judge)
      @scores_in_progress = current_judge.submission_scores.current_round.incomplete.not_recused

      if SeasonToggles.display_scores?
        certificate = current_account.current_judge_certificates.last
        @certificate_file_url = certificate&.file_url
      end
    end

    private

    def create_judge_mentor_on_dashboard
      return if current_session.authenticated?
        # Chapter ambassador/Admin Logged in as someone else

      return if !current_account.authenticated?

      return if current_account.is_not_a_judge? && current_account.is_an_ambassador?

      if CreateJudgeProfile.(current_account)
        flash.now[:success] = t(
          "controllers.judge.dashboards.show.judge_profile_created"
        )
      end
    end
  end
end
