module Admin
  class ScoresController < AdminController
    include DatagridController

    helper_method :grid_params

    use_datagrid(
      with: ScoredSubmissionsGrid,
      to_csv: ScoresGrid
    )

    before_action -> {
      unless request.xhr?
        @scores = SubmissionScore.current.public_send(grid_params[:round])
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
      round = SeasonToggles.current_judging_round(full_name: true).to_s
      passed_round = params[:scored_submissions_grid].fetch(:round) { round }

      if passed_round.blank? && round === 'off'
        round = 'quarterfinals'
      elsif passed_round.blank?
        round = round
      else
        round = passed_round
      end

      if request.xhr?
        {
          round: round
        }
      else
        grid = (params[:scored_submissions_grid] ||= {}).merge(
          admin: true,
          country: Array(params[:scored_submissions_grid][:country]),
          state_province: Array(params[:scored_submissions_grid][:state_province]),
          current_account: current_account,
          round: round,
        )

        grid.merge(
          column_names: detect_extra_columns(grid),
        )
      end
    end
  end
end
