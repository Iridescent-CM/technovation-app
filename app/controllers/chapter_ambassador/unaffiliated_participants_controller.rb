module ChapterAmbassador
  class UnaffiliatedParticipantsController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: UnaffiliatedParticipantsGrid,

      html_scope: ->(scope, user, params) {
        scope = scope
          .current
          .left_outer_joins(:student_profile, :mentor_profile)
          .where("student_profiles.id IS NOT NULL OR mentor_profiles.id IS NOT NULL")

        scope = if user.account.current_chapter&.country.present?
          scope.where(country: user.account.current_chapter.country_code)
        else
          scope.in_region(user)
        end

        scope.where(no_chapter_selected: true).page(params[:page])
      },

      csv_scope: "->(scope, user, params) { " +
        "scope = scope.current.left_outer_joins(:student_profile, :mentor_profile)" +
        ".where('student_profiles.id IS NOT NULL OR mentor_profiles.id IS NOT NULL'); " +
        "scope = if user.account.current_chapter&.country.present?; " +
        "scope.where(country: user.account.current_chapter.country_code); " +
        "else; scope.in_region(user); end; " +
        "scope.where(no_chapter_selected: true) " +
        "}"

    private

    def grid_params
      grid = (params[:unaffiliated_participants_grid] ||= {}).merge(
        admin: false,
        allow_state_search: false,
        chapter_id: current_ambassador.account.current_chapter.id,
        country: [country_code],
        state_province: Array(params[:unaffiliated_participants_grid][:state_province]),
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end

    def country_code
      current_ambassador.account.current_chapter&.country_code.presence || current_ambassador.country_code
    end
  end
end
