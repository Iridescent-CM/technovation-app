module Admin
  class ScoreDetailsController < AdminController
    def show
      @submission = TeamSubmission.includes(:team, :scores_including_deleted)
        .find(params.fetch(:id))

      render 'chapter_ambassador/score_details/show'
    end
  end
end
