module Judge
  class ScoresController < JudgeController
    def new
      respond_to do |f|
        f.html { }

        f.json {
          submission_id = FindEligibleSubmissionId.(
            current_judge,
            { score_id: params[:score_id] }
          )

          submission = TeamSubmission.find(submission_id)

          questions = Questions.new(current_judge, submission)

          render json: questions
        }
      end
    end

    def update
      score = current_judge.submission_scores.find(params[:id])

      if score.update(score_params)
        render json: score
      else
        render json: score.errors
      end
    end

    private
    def score_params
      params.require(:submission_score).permit(
        :sdg_alignment,
        :evidence_of_problem,
        :problem_addressed,
        :ideation_comment,

        :app_functional,
        :demo_video,
        :technical_comment,

        :problem_clearly_communicated,
        :compelling_argument,
        :passion_energy,
        :pitch_specific,
        :pitch_comment,

        :viable_business_model,
        :market_research,
        :business_plan_long_term,
        :business_plan_short_term,
        :entrepreneurship_comment,

        :business_plan_feasible,
        :submission_thought_out,
        :cohesive_story,
        :solution_originality,
        :solution_stands_out,
        :overall_comment,
      )
    end
  end
end
