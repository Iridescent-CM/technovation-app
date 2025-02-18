module Ambassador
  class ScoreDetailsController < AmbassadorController
    layout "ambassador"

    def show
      @submission = TeamSubmission
        .includes(:team, :submission_scores)
        .find(params.fetch(:id))
    end
  end
end
