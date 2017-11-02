module Admin
  class TeamsController < AdminController
    include DatagridUser

    def index
      respond_to do |f|
        f.html do
          @teams_grid = TeamsGrid.new(grid_params) do |scope|
            scope.page(params[:page])
          end
        end

        f.csv do
          @teams_grid = TeamsGrid.new(grid_params)
          send_export(@teams_grid, :csv)
        end
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

    def param_root
      :teams_grid
    end
  end
end
