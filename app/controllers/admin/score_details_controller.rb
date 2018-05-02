module Admin
  class ScoreDetailsController < AdminController
    def show
      @submission = TeamSubmission.includes(:team, :submission_scores)
        .find(params.fetch(:id))

      render 'regional_ambassador/score_details/show'
    end
  end
end