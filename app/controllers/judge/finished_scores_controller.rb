module Judge
  class FinishedScoresController < JudgeController
    def show
      @score = current_judge.submission_scores.find(params.fetch(:id))
    end
  end
end
