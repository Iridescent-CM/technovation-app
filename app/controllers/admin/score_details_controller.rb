module Admin
  class ScoreDetailsController < AdminController
    def show
      @submission = TeamSubmission.includes(:team)
        .find(params.fetch(:id))
      @recused_scores = @submission.submission_scores.recused.includes(judge_profile: :account)

      render "ambassador/score_details/show"
    end
  end
end
