module Student
  class ScoresController < StudentController
    def index
      @all_scores = SubmissionScore.none
      @quarterfinals_scores = SubmissionScore.none
      @semifinals_scores = SubmissionScore.none

      if current_team.submission.present? && SeasonToggles.display_scores?
        @all_scores = current_team.submission.submission_scores.complete
        @quarterfinals_scores = @all_scores.quarterfinals

        if current_team.submission.semifinalist? ||
            current_team.submission.regional_honoree? ||
            current_team.submission.special_prize_winner? ||
            current_team.submission.finalist? ||
            current_team.submission.grand_prize_winner?

          @semifinals_scores = @all_scores.semifinals
        end
      end

      @certificates = Certificate.none
      @previous_certificates = current_account.certificates.highest_awarded_student_certs_for_previous_seasons

      if SeasonToggles.display_scores?
        @highest_current_certificate = current_account.certificates.highest_awarded_student_cert_for_current_season
      end

      render template: "student/scores/index"
    end

    def show
      submission_id = TeamSubmission.where(team_id: current_team.id)

      @score = SubmissionScore.where(team_submission_id: submission_id).find(params[:id])
      @team = @score.team
      @team_submission = @team.submission

      render "student/scores/score_details"
    end
  end
end
