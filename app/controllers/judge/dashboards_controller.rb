require 'fill_pdfs'

module Judge
  class DashboardsController < JudgeController
    def show
      @regional_events = RegionalPitchEvent.available_to(current_judge)
      @score_in_progress = ScoreInProgress.new(current_judge)

      if SeasonToggles.display_scores?
        FillPdfs.(current_account)
        recipient = CertificateRecipient.new(current_account)
        @certificate_file_url = recipient.certificate_url
        @badge_recipient = BadgeRecipient.new(current_judge)
      end
    end

    private
    def create_mentor_judge_on_dashboard
      return if current_session.authenticated?
        # RA/Admin Logged in as someone else

      if CreateJudgeProfile.(current_account)
        flash.now[:success] = t(
          "controllers.judge.dashboards.show.judge_profile_created"
        )
      elsif current_account.authenticated? and is_not_and_cannot_be_judge?
        redirect_to root_path,
          alert: "You don't have permission to go there!"
      end
    end

    def is_not_and_cannot_be_judge?
      not current_account.judge_profile.present? and
        not current_account.can_be_a_judge?
    end
  end
end
