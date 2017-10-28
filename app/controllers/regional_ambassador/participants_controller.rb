module RegionalAmbassador
  class ParticipantsController < RegionalAmbassadorController
    def index
      @saved_searches = current_ambassador.saved_searches
        .for_param_root(:accounts_grid)

      @saved_search = current_ambassador.saved_searches.build

      grid_params = (params[:accounts_grid] ||= {}).merge(
        admin: false,
        country: [current_ambassador.country],
        state_province: (
          if current_ambassador.country == "US"
            [current_ambassador.state_province]
          else
            params[:accounts_grid][:state_province] || []
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

    private
    def detect_extra_columns
      columns = params[:accounts_grid][:column_names] ||= []

      if (params[:accounts_grid][:country] || []).any?
        columns << :country
      end

      if (params[:accounts_grid][:state_province] || []).any?
        columns << :state_province
      end

      if (params[:accounts_grid][:city] || []).any?
        columns << :city
      end

      columns
    end
  end
end
