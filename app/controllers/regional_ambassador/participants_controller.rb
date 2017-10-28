module RegionalAmbassador
  class ParticipantsController < RegionalAmbassadorController
    include DatagridUser

    def index
      grid_params = (params[:accounts_grid] ||= {}).merge(
        admin: false,
        country: [current_ambassador.country],
        state_province: (
          if current_ambassador.country == "US"
            [current_ambassador.state_province]
          else
            Array(params[:accounts_grid][:state_province])
          end
        ),
        season: params[:accounts_grid][:season] || Season.current.year,
        column_names: detect_extra_columns,
      )

      @accounts_grid = AccountsGrid.new(grid_params) do |scope|
        scope.in_region(current_ambassador).page(params[:page])
      end
    end

    def show
      @account = Account.in_region(current_ambassador).find(params[:id])
    end
  end
end
