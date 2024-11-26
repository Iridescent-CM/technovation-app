module ChapterAmbassador
  class TeamsController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: TeamsGrid,
      html_scope: ->(scope, user, params) {
        scope
          .by_student_chapter(user.current_chapter.id)
          .distinct
          .page(params[:page])
      },
      csv_scope: "->(scope, user, params) {
        scope
          .by_student_chapter(user.current_chapter.id)
          .distinct
      }"

    def show
      @team = Team.by_student_chapter(current_ambassador.current_chapter.id).find(params[:id])
    end

    def edit
      @team = Team.by_student_chapter(current_ambassador.current_chapter.id).find(params[:id])
    end

    def update
      @team = Team.by_student_chapter(current_ambassador.current_chapter.id).find(params[:id])

      if TeamUpdating.execute(@team, team_params)
        redirect_to chapter_ambassador_team_path, success: "Team changes saved!"
      else
        redirect_to chapter_ambassador_team_path, error: "Error saving team photo. Please try again later."
      end
    end

    private

    def team_params
      params.require(:team).permit(
        :team_photo
      )
    end

    def grid_params
      grid = (params[:teams_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:teams_grid][:state_province])
          end
        ),
        season: params[:teams_grid][:season] || Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
