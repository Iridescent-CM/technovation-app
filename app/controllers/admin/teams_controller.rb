module Admin
  class TeamsController < AdminController
    def index
      @teams = Team.none
    end

    def show
      @team = Team.find(params[:id])
    end

    def edit
      @team = Team.find(params[:id])
    end

    def update
      @team = Team.find(params[:id])

      if TeamUpdating.execute(@team, team_params)
        redirect_to [:admin, @team], success: "Team changes saved!"
      else
        render :edit
      end
    end

    private
    def team_params
      params.require(:team).permit(
        :name,
        :description,
        :city,
        :state_province,
        :country
      )
    end
  end
end
