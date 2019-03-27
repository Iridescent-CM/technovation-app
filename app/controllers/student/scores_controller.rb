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
  end
end