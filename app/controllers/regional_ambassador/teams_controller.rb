module RegionalAmbassador
  class TeamsController < RegionalAmbassadorController
    include DatagridUser

    def index
      respond_to do |f|
        f.html do
          @teams_grid = TeamsGrid.new(grid_params) do |scope|
            scope.in_region(current_ambassador).page(params[:page])
          end
        end

        f.csv do
          @teams_grid = TeamsGrid.new(grid_params) do |scope|
            scope.in_region(current_ambassador)
          end
          send_export(@teams_grid, :csv)
        end
      end
    end

    def show
      @team = Team.in_region(current_ambassador).find(params[:id])
    end

    private
    def grid_params
      grid = (params[:teams_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country != "US",
        country: [current_ambassador.country],
        state_province: (
          if current_ambassador.country == "US"
            [current_ambassador.state_province]
          else
            Array(params[:teams_grid][:state_province])
          end
        ),
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
