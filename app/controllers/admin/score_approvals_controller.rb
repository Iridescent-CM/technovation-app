module Admin
  class ScoreApprovalsController < AdminController
    def create
      score = SubmissionScore.find(params.fetch(:id))
      score.approve!
      redirect_to admin_scores_path,
        success: "You approved a score by #{score.judge_name}"
    end
  end
end
