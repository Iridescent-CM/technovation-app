module ChapterAmbassador
  class ScoresController < ChapterAmbassadorController
    def show
      @score = SubmissionScore.find(params.fetch(:id))

      render "admin/scores/show"
    end
  end
end
