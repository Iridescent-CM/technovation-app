
module Admin
  class TeamSubmissionsController < AdminController
    include DatagridUser

    use_datagrid with: SubmissionsGrid

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
    end

    def edit
    end

    def update
    end

    private
    def grid_params
      grid = (params[:submissions_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:submissions_grid][:country]),
        state_province: Array(params[:submissions_grid][:state_province]),
        season: params[:submissions_grid][:season] || Season.current.year,
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
