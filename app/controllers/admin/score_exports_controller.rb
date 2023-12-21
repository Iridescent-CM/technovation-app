module Admin
  class ScoreExportsController < AdminController
    include DatagridController

    helper_method :grid_params

    use_datagrid with: ScoresGrid

    private

    def grid_params
      grid = params[:scores_grid] ||= {}

      current_round = SeasonToggles.current_judging_round(full_name: true).to_s
      passed_round = params[:scores_grid].fetch(:round) { "" }

      round = if !passed_round.blank?
        passed_round
      elsif ["semifinals", "finished"].include?(current_round)
        "semifinals"
      else
        "quarterfinals"
      end

      grid.merge({
        round: round,
        column_names: detect_extra_columns(grid)
      })
    end
  end
end
