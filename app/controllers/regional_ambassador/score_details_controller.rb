module RegionalAmbassador
  class ScoreDetailsController < RegionalAmbassadorController
    def show
      @submission = TeamSubmission.includes(:team, :submission_scores)
        .find(params.fetch(:id))
    end
  end
end