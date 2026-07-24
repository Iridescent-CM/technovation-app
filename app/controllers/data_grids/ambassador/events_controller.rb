module DataGrids::Ambassador
  class EventsController < AmbassadorController
    include DatagridController

    layout "ambassador"

    use_datagrid with: EventsGrid,
      html_scope: ->(scope, user, params) {
        scope
          .current
          .in_region(user.chapterable)
          .page(params[:page])
      },

      csv_scope: "->(scope, user, params) {
        scope
          .current
          .in_region(user.chapterable)
      }"

    private

    def grid_params
      permitted = permitted_grid_params
      grid = permitted.merge(
        admin: false,
        country: Array(permitted[:country]),
        state_province: Array(permitted[:state_province])
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
