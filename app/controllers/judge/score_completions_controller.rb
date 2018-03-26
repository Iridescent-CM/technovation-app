module Judge
  class ScoreCompletionsController < JudgeController
    def create
      score = current_judge.submission_scores.find(params.fetch(:id))
      score.complete!
      redirect_to judge_finished_score_path(score),
        success: "Thank you for scoring! Keep up the good work!"
    end
  end
end
