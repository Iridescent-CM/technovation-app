module ChapterAmbassador
  class ScoreDetailsController < ChapterAmbassadorController
    def show
      @submission = TeamSubmission.includes(:team, :submission_scores)
        .find(params.fetch(:id))
    end
  end
end
