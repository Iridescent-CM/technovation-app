module DataGrids::Ambassador
  class TeamsController < ::AmbassadorController
    include DatagridController

    layout "ambassador"

    use_datagrid with: TeamsGrid,
      html_scope: ->(scope, user, params) {
        scope
          .by_chapterable(
            user.chapterable_type,
            user.current_chapterable.id
          )
          .distinct
          .page(params[:page])
      },
      csv_scope: "->(scope, user, params) {
        scope
          .by_chapterable(
      user.chapterable_type,
      user.current_chapterable.id)
          .distinct
      }"

    private

    def grid_params
      grid = (params[:teams_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:teams_grid][:state_province])
          end
        ),
        season: params[:teams_grid][:season] || Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
