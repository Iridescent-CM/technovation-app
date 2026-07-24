# frozen_string_literal: true

module Admin
  class SecurityEventsController < AdminController
    include DatagridController

    use_datagrid with: SecurityEventsGrid

    private

    def grid_params
      grid = permitted_grid_params

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
