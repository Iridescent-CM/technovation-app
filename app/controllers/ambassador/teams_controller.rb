module Ambassador
  class TeamsController < AmbassadorController
    def show
      @team = Team.by_chapterable(
        current_ambassador.chapterable_type,
        current_ambassador.current_chapterable.id
      ).find(params[:id])
    end
  end
end
