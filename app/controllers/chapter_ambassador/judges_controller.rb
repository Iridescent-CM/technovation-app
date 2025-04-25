module ChapterAmbassador
  class JudgesController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: JudgesGrid,
      html_scope: ->(scope, user, params) {
        judges_grid = params.fetch(:judges_grid) { {} }

        if !judges_grid[:by_event].blank?
          scope.page(params[:page])
        else
          scope.in_region(user).page(params[:page])
        end
      },

      csv_scope: "->(scope, user, params) { " +
        "if not params[:by_event].blank?; scope; " +
        "else; user.account; scope.in_region(user); end " +
        "}"

    private

    def grid_params
      grid = (params[:judges_grid] ||= {}).merge(
        current_account: current_ambassador.account,
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:judges_grid][:state_province])
          end
        )
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
