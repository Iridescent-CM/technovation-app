module Ambassador
  class TeamsController < AmbassadorController
    def show
      @team = Team.by_chapterable(
        current_ambassador.chapterable_type,
        current_ambassador.current_chapterable.id
      ).find(params[:id])
    end

    def edit
      @team = Team.by_chapterable(
        current_ambassador.chapterable_type,
        current_ambassador.current_chapter.id
      ).find(params[:id])
    end

    def update
      @team = Team.by_chapter(current_ambassador.current_chapter.id).find(params[:id])

      if TeamUpdating.execute(@team, team_params)
        redirect_to chapter_ambassador_team_path, success: "Team changes saved!"
      else
        redirect_to chapter_ambassador_team_path, error: "Error saving team photo. Please try again later."
      end
    end

    private

    def team_params
      params.require(:team).permit(
        :team_photo
      )
    end
  end
end
