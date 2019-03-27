require 'fill_pdfs'

module Judge
  class DashboardsController < JudgeController
    include LocationStorageController

    def show
      @regional_events = RegionalPitchEvent.available_to(current_judge)
      @score_in_progress = ScoreInProgress.new(current_judge)

      if SeasonToggles.display_scores?
        FillPdfs.(current_account)
        recipient = CertificateRecipient.new(current_account)
        @certificate_file_url = recipient.certificate_url
      end
    end

    private
    def is_not_and_cannot_be_judge?
      not current_account.judge_profile.present? and
        not current_account.can_be_a_judge?
    end

    def create_judge_mentor_on_dashboard
      return if current_session.authenticated?
        # RA/Admin Logged in as someone else

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
