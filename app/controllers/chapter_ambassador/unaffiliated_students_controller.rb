module ChapterAmbassador
  class UnaffiliatedStudentsController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: UnaffiliatedStudentsGrid,

      html_scope: ->(scope, user, params) {
        if user.account.current_chapter&.country.present?
          scope.where(country: user.account.current_chapter.country)
        else
          scope.in_region(user)
        end

        scope.page(params[:page])
      },

      csv_scope: "->(scope, user, params) { "+
        "if user.account.current_chapter&.country.present? " +
        "scope.where(country: user.account.current_chapter.country) " +
        "else scope.in_region(user) end" +
        "scope.page(params[:page]) } "

    private

    def grid_params
      grid = (params[:unaffiliated_students_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:unaffiliated_students_grid][:state_province])
          end
        ),
        season: params[:unaffiliated_students_grid][:season] || Season.current.year,
        season_and_or: params[:unaffiliated_students_grid][:season_and_or] ||
                         "match_any"
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
