module Admin
  class ScoresController < AdminController
    include DatagridController

    helper_method :grid_params

    use_datagrid with: ScoredSubmissionsGrid

    before_action -> {
      unless request.xhr?
        @round = grid_params[:round]
      end
    }, only: :index

    def show
      @score = SubmissionScore.find(params.fetch(:id))
    end

    def destroy
      score = SubmissionScore.find(params.fetch(:id))
      score.destroy
      redirect_to admin_scores_path,
        success: "You deleted a score by #{score.judge_name}"
    end

    private
    def grid_params
      grid = params[:scored_submissions_grid] ||= {}

      round = 'quarterfinals'
      current_round = SeasonToggles.current_judging_round(full_name: true).to_s
      passed_round = params[:scored_submissions_grid].fetch(:round) { "" }

      if not passed_round.blank?
        round = passed_round
      elsif current_round === 'off'
        round = 'quarterfinals'
      elsif passed_round.blank?
        round = current_round
      end

      grid.merge({
        admin: true,
        country: Array(params[:scored_submissions_grid][:country]),
        state_province: Array(params[:scored_submissions_grid][:state_province]),
        current_account: current_account,
        round: round,
        column_names: detect_extra_columns(grid),
      })
    end
  end
end
