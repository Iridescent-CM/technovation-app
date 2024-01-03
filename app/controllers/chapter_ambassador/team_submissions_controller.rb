module ChapterAmbassador
  class TeamSubmissionsController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: SubmissionsGrid,

      html_scope: ->(scope, user, params) {
        scope.in_region(user).page(params[:page])
      },

      csv_scope: "->(scope, user, params) { scope.in_region(user) }"

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
    end

    private

    def grid_params
      grid = (params[:submissions_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:submissions_grid][:state_province])
          end
        ),
        season: params[:submissions_grid][:season] || Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
