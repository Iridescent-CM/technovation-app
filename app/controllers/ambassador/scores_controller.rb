module Ambassador
  class ScoresController < AmbassadorController
    def show
      @score = SubmissionScore.find(params.fetch(:id))

      render "admin/scores/show"
    end
  end
end
