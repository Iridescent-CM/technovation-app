module ChapterAmbassador
  class JudgesController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: JudgesGrid,
      html_scope: ->(scope, user, params) {
        judges_grid = params.fetch(:judges_grid) { {} }

        if not judges_grid[:by_event].blank?
          scope.page(params[:page])
        else
          scope.in_region(user).page(params[:page])
        end
      },

      csv_scope: "->(scope, user, params) { " +
          "if not params[:by_event].blank?; scope; " +
          "else; user.account; scope.in_region(user); end " +
        "}"

    private
    def grid_params
      params[:judges_grid] ||= {}
      grid = GridParams.for(params[:judges_grid], current_ambassador, admin: false)
      grid.merge(column_names: detect_extra_columns(grid))
    end
  end
end
