module RegionalAmbassador
  class TeamsController < RegionalAmbassadorController
    def index
      params[:division] ||= "All"
      @teams = RegionalTeam.(current_ambassador, params)
                           .paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @team = Team.find(params[:id])
    end
  end
end
