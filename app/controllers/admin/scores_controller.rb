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
      @score = SubmissionScore.with_deleted.find(params.fetch(:id))
    end

    def destroy
      score = SubmissionScore.find(params.fetch(:id))
      score.destroy
      redirect_to admin_scores_path,
        success: "You deleted a score by #{score.judge_name}"
    end

    def restore
      score = SubmissionScore.with_deleted.find(params.fetch(:score_id))
      score.restore

      redirect_back fallback_location: admin_scores_path,
        success: "This score has been restored"
    end

    private

    def grid_params
      grid = params[:scored_submissions_grid] ||= {}

      current_round = SeasonToggles.current_judging_round(full_name: true).to_s
      passed_round = params[:scored_submissions_grid].fetch(:round) { "" }

      round = if !passed_round.blank?
        passed_round
      elsif ["semifinals", "finished"].include?(current_round)
        "semifinals"
      else
        "quarterfinals"
      end

      grid.merge({
        admin: true,
        country: Array(params[:scored_submissions_grid][:country]),
        state_province: Array(params[:scored_submissions_grid][:state_province]),
        current_account: current_account,
        round: round,
        column_names: detect_extra_columns(grid)
      })
    end
  end
end
