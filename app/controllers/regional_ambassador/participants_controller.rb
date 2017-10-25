module RegionalAmbassador
  class ParticipantsController < RegionalAmbassadorController
    def index
      grid_params = (params[:accounts_grid] ||= {}).merge(
        country: current_ambassador.country,
        state_province: (
          params[:accounts_grid][:state_province] ||
            current_ambassador.state_province
        ),
        season: params[:accounts_grid][:season] || Season.current.year,
      )

      @accounts_grid = AccountsGrid.new(grid_params) do |scope|
        scope.page(params[:page])
      end
    end

    def show
      @account = Account.in_region(current_ambassador).find(params[:id])
    end
  end
end
