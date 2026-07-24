module Admin
  class BackgroundChecksController < AdminController
    include DatagridController
    use_datagrid with: BackgroundChecksGrid

    private

    def grid_params
      grid = permitted_grid_params

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
