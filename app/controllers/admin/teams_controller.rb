module Admin
  class TeamsController < AdminController
    def index
      teams = SearchTeams.(params)
      @teams = teams.paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @team = Team.find(params[:id])
    end

    def edit
      @team = Team.find(params[:id])
    end

    def update
      @team = Team.find(params[:id])

      if @team.update_attributes(team_params)
        redirect_to [:admin, @team], success: "Team changes saved!"
      else
        render :edit
      end
    end

    private
    def team_params
      params.require(:team).permit(:name, :description)
    end
  end
end
