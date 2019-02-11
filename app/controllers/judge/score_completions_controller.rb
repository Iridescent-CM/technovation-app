module Judge
  class ScoreCompletionsController < JudgeController
    def create
      if SeasonToggles.judging_enabled_for?(current_judge)
        score = current_judge.submission_scores.find(params.fetch(:id))
        score.complete!
        redirect_to judge_finished_score_path(score),
          success: "Thank you for scoring! Keep up the good work!"
      else
        redirect_to root_path, alert: "Judging is not open right now"
      end
    end
  end
end
