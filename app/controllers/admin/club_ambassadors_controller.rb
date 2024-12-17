module Admin
  class ClubAmbassadorsController < AdminController
    include DatagridController

    use_datagrid with: ClubAmbassadorsGrid

    def grid_params
      grid = params[:club_ambassadors_grid] ||= {}
      grid.merge(
        column_names: detect_extra_columns(grid),
        season: params[:club_ambassadors_grid].present? ? params[:club_ambassadors_grid][:season] : Season.current.year
      )
    end
  end
end
