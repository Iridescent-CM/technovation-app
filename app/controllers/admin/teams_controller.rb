module Admin
  class TeamsController < AdminController
    include DatagridController

    use_datagrid with: TeamsGrid

    def show
      @team = Team.find(params[:id])
    end

    def edit
      @team = Team.find(params[:id])
    end

    def update
      @team = Team.find(params[:id])

      if TeamUpdating.execute(@team, team_params)
        redirect_to admin_team_path, success: "Team changes saved!"
      else
        render :edit
      end
    end

    private
    def team_params
      params.require(:team).permit(
        :name,
        :description,
        :team_photo,
        :city,
        :state_province,
        :country
      )
    end

    def grid_params
      grid = (params[:teams_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:teams_grid][:country]),
        state_province: Array(params[:teams_grid][:state_province]),
        season: params[:teams_grid][:season] || Season.current.year,
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
