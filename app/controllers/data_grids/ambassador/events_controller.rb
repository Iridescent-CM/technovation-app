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
      grid = (params[:events_grid] ||= {}).merge(
        admin: false,
        country: Array(params[:events_grid][:country]),
        state_province: Array(params[:events_grid][:state_province])
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
