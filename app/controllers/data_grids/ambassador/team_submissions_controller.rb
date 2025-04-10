module DataGrids::Ambassador
  class TeamSubmissionsController < AmbassadorController
    include DatagridController

    layout "ambassador"

    use_datagrid with: SubmissionsGrid,

      html_scope: ->(scope, user, params) {
        if user.chapter_ambassador_profile&.national_view?
          scope
            .in_region(user.chapterable)
            .page(params[:page])
        else
          scope
            .by_chapterable(
              user.chapterable_type,
              user.current_chapterable.id
            )
            .distinct
            .page(params[:page])
        end
      },

      csv_scope: "->(scope, user, params) {
        if user.chapter_ambassador_profile&.national_view?
          scope
            .in_region(user.chapterable)
        else
          scope.by_chapterable(
              user.chapterable_type,
              user.current_chapterable.id
          )
          .distinct
        end
      }"


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
