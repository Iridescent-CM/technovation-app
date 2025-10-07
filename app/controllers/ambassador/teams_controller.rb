module Ambassador
  class TeamsController < AmbassadorController
    include Admin::TeamCreationConcern

    layout "ambassador"

    def show
      @team = if current_ambassador.national_view?
        Team.in_region(current_ambassador.chapter)
          .find(params.fetch(:id))
      else
        Team.by_chapterable(
          current_ambassador.chapterable_type,
          current_ambassador.current_chapterable.id
        ).find(params[:id])
      end
    end
  end
end
