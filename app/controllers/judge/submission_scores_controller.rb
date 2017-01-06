module Judge
  class SubmissionScoresController < JudgeController
    def new
      @submission_score = current_judge.submission_scores.find_or_create_by!(
        team_submission_id: current_team_submission.id
      )
    end

    def update
      @submission_score = current_judge.submission_scores.find(submission_score_params[:id])

      if @submission_score.update_attributes(submission_score_params)
        render json: @submission_score
      else
        render json: @submission_score.errors, status: 422
      end
    end

    private
    def submission_score_params
      params.require(:submission_score).permit(
        :id,
        :sdg_alignment,
        :evidence_of_problem,
        :problem_addressed,
        :ideation_comment,
      ).tap do |tapped|
        tapped[:team_submission_id] = current_team_submission.id
      end
    end

    def current_team_submission
      params[:team_submission_id] ||= TeamSubmission.pluck(:id).sample

      begin
        @current_team_submission ||= TeamSubmission.find(params[:team_submission_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to judge_dashboard_path,
          notice: t("controllers.judge.submission_scores.any.no_submission_found")
      end
    end
  end
end
