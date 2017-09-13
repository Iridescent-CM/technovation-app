module RegionalAmbassador
  class TeamsController < RegionalAmbassadorController
    def index
    end

    def show
      @team = Team.find(params[:id])
    end
  end
end
