module RegionalAmbassador
  class ScoresController < RegionalAmbassadorController
    include DatagridController

    use_datagrid with: ScoredSubmissionsGrid,

      html_scope: ->(scope, user, params) {
        scored_submissions_grid = params.fetch(:scored_submissions_grid) { {} }

        if not scored_submissions_grid[:by_event].blank?
          scope.page(params[:page])
        elsif SeasonToggles.display_scores?
          scope.in_region(user).page(params[:page])
        else
          scope.live.in_region(user).page(params[:page])
        end
      },

      csv_scope: "->(scope, user, params) { " +
          "if not params[:by_event].blank?; scope; " +
          "elsif SeasonToggles.display_scores?; scope.in_region(user); " +
          "else; scope.live.in_region(user); end " +
        "}"

    def show
      @score = SubmissionScore.find(params.fetch(:id))
      render 'admin/scores/show'
    end

    private
    def grid_params
      grid = params[:scored_submissions_grid] ||= {}

      if SeasonToggles.display_scores?
        round = grid.fetch(:round) { 'quarterfinals' }
      else
        round = 'quarterfinals'
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
        column_names: detect_extra_columns(grid),
      )
    end
  end
end