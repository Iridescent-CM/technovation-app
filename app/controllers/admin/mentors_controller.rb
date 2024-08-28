module Admin
  class MentorsController < AdminController
    include DatagridController

    use_datagrid with: MentorsGrid

    def grid_params
      grid = params[:mentors_grid] ||= {}
      grid.merge(
        admin: true,
        column_names: detect_extra_columns(grid),
        season: params[:mentors_grid].present? ? params[:mentors_grid][:season] : Season.current.year
      )
    end
  end
end
