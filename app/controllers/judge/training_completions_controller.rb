module Judge
  class TrainingCompletionsController < JudgeController
    def show
      current_judge.complete_training!
      redirect_to judge_dashboard_path
    end
  end
end
