module Judge
  class ScoresController < JudgeController
    before_action :require_onboarded

    def index
      render json: {
        finished: current_judge.submission_scores
                    .includes(team_submission: :team)
                    .references(:team_submissions)
                    .order("team_submissions.app_name")
                    .current_round.complete.map { |score|
                      {
                        id: score.id,
                        submission_name: score.team_submission.app_name,
                        team_name: score.team_submission.team_name,
                        team_division: score.team_submission
                                            .team_division_name,
                        total: score.total,
                        possible: score.total_possible,
                        url: new_judge_score_path(score_id: score.id),
                      }
                    },
      }
    end

    def new
      respond_to do |f|
        f.html { }

        f.json {
          if submission_id = FindEligibleSubmissionId.(
               current_judge,
               { score_id: params[:score_id] }
             )

            submission = TeamSubmission.find(submission_id)

            questions = Questions.new(current_judge, submission)

            render json: questions
          else
            render json: {
              msg: "There are no more eligible submissions " +
                   "for you to judge now. This is not an error. " +
                   "Thank you for your contribution!",
            }, status: 404
          end
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
