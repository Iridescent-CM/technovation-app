module DataGrids::Ambassador
  class UnaffiliatedParticipantsController < ::AmbassadorController
    include DatagridController

    layout "ambassador"

    use_datagrid with: UnaffiliatedParticipantsGrid,

      html_scope: ->(scope, user, params) {
        scope = scope
          .current
          .left_outer_joins(:student_profile, :mentor_profile)
          .where("student_profiles.id IS NOT NULL OR mentor_profiles.id IS NOT NULL")

        scope = if user.current_chapterable&.country.present?
          scope.where(country: user.current_chapterable.country_code)
        else
          scope.in_region(user)
        end

        scope.where(no_chapterable_selected: true).page(params[:page])
      },

      csv_scope: "->(scope, user, params) { " \
        "scope = scope.current" \
        ".left_outer_joins(:student_profile, :mentor_profile)" \
        ".where('student_profiles.id IS NOT NULL OR mentor_profiles.id IS NOT NULL'); " \
        "scope = if user.current_chapterable&.country.present?; " \
        "scope.where(country: user.current_chapterable.country_code); " \
        "else; scope.in_region(user); end; " \
        "scope.where(no_chapterable_selected: true) " \
        "}"

    private

    def grid_params
      grid = (params[:unaffiliated_participants_grid] ||= {}).merge(
        admin: false,
        allow_state_search: true,
        country: [country_code],
        state_province: Array(params[:unaffiliated_participants_grid][:state_province])
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end

    def country_code
      current_ambassador.current_chapterable&.country_code.presence || current_ambassador.country_code
    end
  end
end
