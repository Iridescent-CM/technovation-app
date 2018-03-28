module Judge
  class ScoresController < JudgeController
    before_action :require_onboarded

    def index
      scope = current_judge.submission_scores
        .includes(team_submission: :team)
        .references(:team_submissions)
        .current_round
        .order("team_submissions.app_name")

      render json: {
        finished: scope.complete.map { |score|
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
               {
                 score_id: params[:score_id],
                 team_submission_id: params[:team_submission_id],
               }
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
        :ideation_comment_positivity,
        :ideation_comment_negativity,
        :ideation_comment_neutrality,
        :ideation_comment_word_count,
        :ideation_comment_bad_word_count,

        :app_functional,
        :demo_video,
        :technical_comment,
        :technical_comment_positivity,
        :technical_comment_negativity,
        :technical_comment_neutrality,
        :technical_comment_word_count,
        :technical_comment_bad_word_count,

        :problem_clearly_communicated,
        :compelling_argument,
        :passion_energy,
        :pitch_specific,
        :pitch_comment,
        :pitch_comment_positivity,
        :pitch_comment_negativity,
        :pitch_comment_neutrality,
        :pitch_comment_word_count,
        :pitch_comment_bad_word_count,

        :viable_business_model,
        :market_research,
        :business_plan_long_term,
        :business_plan_short_term,
        :entrepreneurship_comment,
        :entrepreneurship_comment_positivity,
        :entrepreneurship_comment_negativity,
        :entrepreneurship_comment_neutrality,
        :entrepreneurship_comment_word_count,
        :entrepreneurship_comment_bad_word_count,

        :business_plan_feasible,
        :submission_thought_out,
        :cohesive_story,
        :solution_originality,
        :solution_stands_out,
        :overall_comment,
        :overall_comment_positivity,
        :overall_comment_negativity,
        :overall_comment_neutrality,
        :overall_comment_word_count,
        :overall_comment_bad_word_count,
      )
    end
  end
end
