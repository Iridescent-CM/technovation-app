module Judge
  class ScoreCompletionsController < JudgeController
    def create
      score = current_judge.submission_scores.find(params.fetch(:id))
      score.complete!
      redirect_to judge_finished_score_path(score),
        success: "Thank you for your score! Keep it up!"
    end
  end
end
