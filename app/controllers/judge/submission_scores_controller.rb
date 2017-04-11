module Judge
  class SubmissionScoresController < JudgeController
    helper_method :current_team

    def edit
      @submission_score = current_judge.submission_scores.find(params[:id])
      @current_team_submission = @submission_score.team_submission
      render :new
    end

    def new
      if params[:id]
        @submission_score = current_judge.submission_scores.find(params[:id])
        @current_team_submission = @submission_score.team_submission
      else
        @submission_score = current_judge.submission_scores.find_or_create_by!(
          team_submission_id: current_team_submission.id,
          event_type: current_judge.selected_regional_pitch_event.live? ? "live" : "virtual",
        )
      end

      @submission_score.team_submission.update_attributes({
        judge_opened_id: current_judge.id,
        judge_opened_at: Time.current,
      })
    end

    def update
      @submission_score = current_judge.submission_scores.find(params[:id])

      if @submission_score.update_attributes(submission_score_params)
        render json: @submission_score
      else
        render json: @submission_score.errors, status: 422
      end
    end

    private
    def submission_score_params
      params.require(:submission_score).permit(
        :completed_at,
        :sdg_alignment,
        :evidence_of_problem,
        :problem_addressed,
        :ideation_comment,
        :app_functional,
        :demo_video,
        :business_plan_short_term,
        :business_plan_long_term,
        :market_research,
        :viable_business_model,
        :entrepreneurship_comment,
        :problem_clearly_communicated,
        :compelling_argument,
        :passion_energy,
        :pitch_specific,
        :pitch_comment,
        :business_plan_feasible,
        :submission_thought_out,
        :cohesive_story,
        :solution_originality,
        :solution_stands_out,
        :overall_comment,
        :technical_comment,
      ).tap do |tapped|
        tapped[:team_submission_id] = current_team_submission.id
      end
    end

    def current_team_submission
      return @current_team_submission if @current_team_submission

      params[:team_submission_id] = FindEligibleSubmissionId.(
        current_judge,
        team_submission_id: params[:team_submission_id]
      )

      begin
        @current_team_submission = TeamSubmission.find(params[:team_submission_id])
        @current_team_submission.build_technical_checklist if @current_team_submission.technical_checklist.blank?
        @current_team_submission
      rescue ActiveRecord::RecordNotFound
        redirect_to judge_dashboard_path,
          notice: t("controllers.judge.submission_scores.any.no_submission_found")
      end
    end

    def current_team
      current_team_submission.team
    end
  end
end
