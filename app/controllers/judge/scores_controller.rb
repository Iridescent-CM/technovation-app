module Judge
  class ScoresController < JudgeController
    before_action :require_onboarded
    before_action :require_judging_enabled, only: [:new, :update]
    before_action :reject_suspended_judge, only: [:new, :update]

    def index
      scope = current_judge.submission_scores
        .current
        .includes(team_submission: :team)
        .references(:team_submissions)
        .order("team_submissions.app_name")

      render json: {
        current_round: SeasonToggles.judging_round,

        finished: {
          qf: scope.quarterfinals.complete.map { |score|
            ScoreSerializer.new(score).serialized_json
          },

          sf: scope.semifinals.complete.map { |score|
            ScoreSerializer.new(score).serialized_json
          },
        },

        incomplete: {
          qf: scope.quarterfinals.incomplete.map { |score|
            ScoreSerializer.new(score).serialized_json
          },

          sf: scope.semifinals.incomplete.map { |score|
            ScoreSerializer.new(score).serialized_json
          },
        },
      }
    end

    def new
      respond_to do |f|
        f.html

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

    def show
      @score = current_judge.scores.find(params.fetch(:id))

      respond_to do |format|
        format.html { render 'admin/scores/show' }
        format.json { render json: ScoreSerializer.new(@score).serialized_json }
      end
    end

    def update
      score = current_judge.submission_scores.find(params[:id])

      if score.update(score_params)
        render json: ScoreSerializer.new(score.reload).serialized_json
      else
        render json: score.errors
      end
    end

    private
    def require_judging_enabled
      respond_to do |f|
        f.html {
          unless SeasonToggles.judging_enabled?
            redirect_to root_path, alert: "Judging is not open right now"
          end
        }

        f.json {
          unless SeasonToggles.judging_enabled?
            render json: {
              msg: "Judging is not open right now"
            }, status: 404
          end
        }
      end
    end

    def reject_suspended_judge
      respond_to do |f|
        f.html

        f.json {
          if current_judge.suspended?
            render json: {
              msg: 'Your account has been suspended, please visit our ' +
                   '<a target="_blank" href="https://iridescentsupport.zendesk.com/hc/en-us/articles/360036011914-Rules-for-Judges">FAQs</a> ' +
                   'to learn more about our monitoring process.'
            }, status: 403
          end
        }
      end
    end

    def score_params
      params.require(:submission_score).permit(
        :ideation_1,
        :ideation_2,
        :ideation_3,
        :ideation_4,
        :ideation_comment,
        :ideation_comment_word_count,

        :technical_1,
        :technical_2,
        :technical_3,
        :technical_4,
        :technical_comment,
        :technical_comment_word_count,

        :pitch_1,
        :pitch_2,
        :pitch_comment,
        :pitch_comment_word_count,

        :entrepreneurship_1,
        :entrepreneurship_2,
        :entrepreneurship_3,
        :entrepreneurship_4,
        :entrepreneurship_comment,
        :entrepreneurship_comment_word_count,

        :overall_1,
        :overall_2,
        :overall_comment,
        :overall_comment_word_count,
      )
    end
  end
end
