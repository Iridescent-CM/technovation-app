module Admin
  class ScoresController < AdminController
    include DatagridController

    use_datagrid with: ScoresGrid

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

      if round === 'off'
        round = 'quarterfinals'
      end

      grid = (params[:scores_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:scores_grid][:country]),
        state_province: Array(params[:scores_grid][:state_province]),
        current_account: current_account,
        round: params[:scores_grid].fetch(:round) { round },
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
