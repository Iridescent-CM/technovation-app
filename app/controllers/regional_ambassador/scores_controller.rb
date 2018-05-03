module RegionalAmbassador
  class ScoresController < RegionalAmbassadorController
    include DatagridController

    use_datagrid with: ScoresGrid,

      html_scope: ->(scope, user, params) {
        scope.in_region(user).page(params[:page])
      },

      csv_scope: "->(scope, user, params) { scope.in_region(user) }"

    def show
      @score = SubmissionScore.find(params.fetch(:id))
      render 'admin/scores/show'
    end

    private
    def grid_params
      round = SeasonToggles.current_judging_round(full_name: true).to_s

      if round === 'off'
        round = 'quarterfinals'
      end

      grid = (params[:scores_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country != "US",
        country: [current_ambassador.country],
        state_province: (
          if current_ambassador.country == "US"
            [current_ambassador.state_province]
          else
            Array(params[:scores_grid][:state_province])
          end
        ),
        current_account: current_account,
        round: params.fetch(:round) { round },
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end