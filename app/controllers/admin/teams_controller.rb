module Admin
  class TeamsController < AdminController
    include DatagridController
    include Admin::TeamCreationConcern

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
      permitted = permitted_grid_params
      grid = permitted.merge(
        admin: true,
        country: Array(permitted[:country]),
        state_province: Array(permitted[:state_province]),
        season: params[:teams_grid].present? ? permitted[:season] : Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
