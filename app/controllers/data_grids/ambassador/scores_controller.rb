module DataGrids::Ambassador
  class ScoresController < AmbassadorController
    include DatagridController

    layout "ambassador"

    use_datagrid with: ScoredSubmissionsGrid,

      html_scope: ->(scope, user, params) {
        scored_submissions_grid = params.fetch(:scored_submissions_grid) { {} }

        if scored_submissions_grid[:by_event].present?
          scope
            .page(params[:page])
        elsif SeasonToggles.display_scores?
          scope
            .by_chapterable(
              user.chapterable_type,
              user.current_chapterable.id
            )
            .page(params[:page])
        else
          scope
            .in_region(user)
            .live
            .page(params[:page])
        end
      },

      csv_scope: "->(scope, user, params) { " \
        "if params[:by_event].present?; scope; " \
        "elsif SeasonToggles.display_scores?; scope.by_chapterable(user.chapterable_type, user.current_chapterable.id); " \
        "else; scope.live.in_region(user); end " \
        "}"

    private

    def grid_params
      grid = params[:scored_submissions_grid] ||= {}

      round = if SeasonToggles.display_scores?
        grid.fetch(:round) { "quarterfinals" }
      else
        "quarterfinals"
      end

      grid.merge(
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:scored_submissions_grid][:state_province])
          end
        ),
        current_account: current_account,
        round: round,
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
