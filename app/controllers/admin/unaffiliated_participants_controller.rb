module Admin
  class UnaffiliatedParticipantsController < AdminController
    include DatagridController

    use_datagrid with: UnaffiliatedParticipantsGrid,
      html_scope: ->(scope, user, params) {
        scope
          .current
          .left_outer_joins(:student_profile, :mentor_profile)
          .where("student_profiles.id IS NOT NULL OR mentor_profiles.id IS NOT NULL")
          .where(no_chapterable_selected: true)
          .or(scope.where(no_chapterables_available: true))
          .page(params[:page])
      },

      csv_scope: "->(scope, user, params) { " \
        "scope.current" \
        ".left_outer_joins(:student_profile, :mentor_profile)" \
        ".where('student_profiles.id IS NOT NULL OR mentor_profiles.id IS NOT NULL') " \
        ".where(no_chapterable_selected: true) " \
        ".or(scope.where(no_chapterables_available: true)) " \
        "}"

    private

    def grid_params
      grid = (params[:unaffiliated_participants_grid] ||= {}).merge(
        admin: true,
        allow_state_search: true,
        country: Array(params[:unaffiliated_participants_grid][:country]),
        state_province: Array(params[:unaffiliated_participants_grid][:state_province])
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
