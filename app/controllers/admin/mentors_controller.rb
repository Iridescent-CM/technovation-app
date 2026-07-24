module Admin
  class MentorsController < AdminController
    include DatagridController

    use_datagrid with: MentorsGrid

    def grid_params
      permitted = permitted_grid_params
      permitted.merge(
        admin: true,
        column_names: detect_extra_columns(permitted),
        season: params[:mentors_grid].present? ? permitted[:season] : Season.current.year
      )
    end
  end
end
