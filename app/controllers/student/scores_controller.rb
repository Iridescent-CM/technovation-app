module Student
  class ScoresController < StudentController
    def index
      @all_scores = SubmissionScore.none
      @quarterfinals_scores = SubmissionScore.none
      @semifinals_scores = SubmissionScore.none

      if current_team.submission.present? and SeasonToggles.display_scores?
        @all_scores = current_team.submission.submission_scores.complete
        @quarterfinals_scores = @all_scores.quarterfinals

        if current_team.submission.semifinalist?
          @semifinals_scores = @all_scores.semifinals
        end
      end

      @certificates = Certificate.none

      if SeasonToggles.display_scores?
        @certificates = current_account.certificates.current
      end

      render template: 'student/scores/index'
    end

    def show
      submission_id = TeamSubmission.where(team_id: current_team.id)

      @score = SubmissionScore.where(team_submission_id: submission_id).find(params[:id])
      @team = @score.team
      @team_submission = @team.submission

      # TODO: Create rebranded template for student score details
      render 'admin/scores/show'
    end

  end
end