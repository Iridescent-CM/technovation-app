module Admin
  class ScoreDetailsController < AdminController
    def show
      @submission = TeamSubmission.includes(:team, :scores_including_deleted)
        .find(params.fetch(:id))
      @recused_scores = @submission.submission_scores.recused

      render "ambassador/score_details/show"
    end
  end
end
