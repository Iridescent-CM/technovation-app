module Admin
  class JudgesController < AdminController
    include DatagridController

    use_datagrid with: JudgesGrid

    private
    def grid_params
      grid = (params[:judges_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:judges_grid][:country]),
        state_province: Array(params[:judges_grid][:state_province]),
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end