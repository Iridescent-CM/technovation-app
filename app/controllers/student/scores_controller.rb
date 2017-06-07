module Student
  class ScoresController < StudentController
    def show
      @score = current_team.submission.submission_scores.complete.find(params[:id])
      @division = @score.team_submission.team.division
    end
  end
end
