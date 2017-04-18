module Admin
  class TeamsController < AdminController
    def index
      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 15 if params[:per_page].blank?

      @teams = Admin::SearchTeams.(params)
        .uniq
        .page(params[:page].to_i)
        .per_page(params[:per_page].to_i)

      if @teams.empty?
        @teams = @teams.page(1)
      end
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
