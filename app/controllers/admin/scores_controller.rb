module Admin
  class ScoresController < AdminController
    include DatagridController

    use_datagrid(
      with: ScoredSubmissionsGrid,
      to_csv: ScoresGrid
    )

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
      if request.xhr?
        {}
      else
        round = SeasonToggles.current_judging_round(full_name: true).to_s

        if round === 'off'
          round = 'quarterfinals'
        end

        grid = (params[:scored_submissions_grid] ||= {}).merge(
          admin: true,
          country: Array(params[:scored_submissions_grid][:country]),
          state_province: Array(params[:scored_submissions_grid][:state_province]),
          current_account: current_account,
          round: params[:scored_submissions_grid].fetch(:round) { round },
        )

        grid.merge(
          column_names: detect_extra_columns(grid),
        )
      end
    end
  end
end
