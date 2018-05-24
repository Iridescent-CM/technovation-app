module Admin
  class JudgesController < AdminController
    include DatagridController

    use_datagrid with: JudgesGrid

    private
    def grid_params
      grid = GridParams.for(params[:judges_grid], current_admin, admin: true)
      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end