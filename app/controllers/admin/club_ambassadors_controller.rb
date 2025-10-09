module Admin
  class ClubAmbassadorsController < AdminController
    include DatagridController

    use_datagrid with: ClubAmbassadorsGrid

    def grid_params
      grid = params[:club_ambassadors_grid] ||= {}
      grid.merge(
        column_names: detect_extra_columns(grid),
        admin: true,
        allow_state_search: true,
        country: Array(params[:club_ambassadors_grid][:country]),
        state_province: Array(params[:club_ambassadors_grid][:state_province])
      )
    end
  end
end
