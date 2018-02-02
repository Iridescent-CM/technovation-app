module RegionalAmbassador
  class ParticipantsController < RegionalAmbassadorController
    include DatagridController

    use_datagrid with: AccountsGrid,
      html_scope: ->(scope, user, params) {
        scope.in_region(user).page(params[:page])
      },
      csv_scope: "->(scope, user, params) { scope.in_region(user) }"

    def show
      @account = Account.in_region(current_ambassador).find(params[:id])
      @teams = Team.current.in_region(current_ambassador)
    end

    private
    def grid_params
      grid = (params[:accounts_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country != "US",
        country: [current_ambassador.country],
        state_province: (
          if current_ambassador.country == "US"
            [current_ambassador.state_province]
          else
            Array(params[:accounts_grid][:state_province])
          end
        ),
        season: params[:accounts_grid][:season] || Season.current.year,
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
