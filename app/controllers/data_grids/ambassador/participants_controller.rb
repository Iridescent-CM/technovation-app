module DataGrids::Ambassador
  class ParticipantsController < AmbassadorController
    include DatagridController

    layout "ambassador"

    use_datagrid with: AccountsGrid,

      html_scope: ->(scope, user, params) {
        scope
          .joins(:chapterable_assignments)
          .where(
            chapterable_assignments: {
              chapterable_type: user.chapterable_type.capitalize,
              chapterable_id: user.current_chapterable.id
            }
          )
          .page(params[:page])
      },

      csv_scope: "->(scope, user, _params) {
        scope
          .joins(:chapterable_assignments)
      .where(chapterable_assignments: {chapterable_type: user.chapterable_type.capitalize, chapterable_id: user.current_chapterable.id})
      }"

    private

    def grid_params
      grid = (params[:accounts_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:accounts_grid][:state_province])
          end
        ),
        season: params[:accounts_grid][:season] || Season.current.year,
        season_and_or: params[:accounts_grid][:season_and_or] ||
                         "match_any"
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
