module Admin
  class ClubAmbassadorsController < AdminController
    include DatagridController

    use_datagrid with: ClubAmbassadorsGrid

    def grid_params
      permitted = permitted_grid_params
      permitted.merge(
        column_names: detect_extra_columns(permitted),
        admin: true,
        allow_state_search: true,
        country: Array(permitted[:country]),
        state_province: Array(permitted[:state_province])
      )
    end
  end
end
