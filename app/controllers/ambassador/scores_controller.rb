module Ambassador
  class ScoresController < AmbassadorController
    def show
      @score = if current_ambassador.national_view?
        SubmissionScore
          .in_region(current_ambassador.chapter)
          .find(params.fetch(:id))
      else
        SubmissionScore
          .by_chapterable(
            current_ambassador.chapterable_type,
            current_ambassador.current_chapterable.id
          )
          .find(params.fetch(:id))
      end

      render "admin/scores/show"
    end
  end
end
