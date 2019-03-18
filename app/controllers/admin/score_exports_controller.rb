module Admin
  class ScoreExportsController < AdminController
    include DatagridController

    helper_method :grid_params

    use_datagrid with: ScoresGrid

    private
    def grid_params
      grid = params[:scores_grid] ||= {}

      round = 'quarterfinals'
      current_round = SeasonToggles.current_judging_round(full_name: true).to_s
      passed_round = params[:scores_grid].fetch(:round) { "" }

      if not passed_round.blank?
        round = passed_round
      elsif current_round === 'off'
        round = 'quarterfinals'
      elsif passed_round.blank?
        round = current_round
      end

      grid.merge({
        round: round,
        column_names: detect_extra_columns(grid),
      })
    end
  end
end
