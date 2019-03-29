module Admin
  class ScoreExportsController < AdminController
    include DatagridController

    helper_method :grid_params

    use_datagrid with: ScoresGrid

    private
    def grid_params
      grid = params[:scores_grid] ||= {}

      current_round = SeasonToggles.current_judging_round(full_name: true).to_s
      passed_round = params[:scored_submissions_grid].fetch(:round) { "" }

      if not passed_round.blank?
        round = passed_round
      elsif ['semifinals', 'finished'].include?(current_round)
        round = 'semifinals'
      else
        round = 'quarterfinals'
      end

      grid.merge({
        round: round,
        column_names: detect_extra_columns(grid),
      })
    end
  end
end
