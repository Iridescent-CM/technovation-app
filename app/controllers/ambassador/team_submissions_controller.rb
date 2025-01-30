module Ambassador
  class TeamSubmissionsController < AmbassadorController
    layout "ambassador"

    def show
      @team_submission = TeamSubmission.by_chapterable(
        current_ambassador.chapterable_type,
        current_ambassador.current_chapterable.id
      ).find(params[:id])
    end
  end
end
