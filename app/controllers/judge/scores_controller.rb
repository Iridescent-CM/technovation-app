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
          }
        },

        not_started: not_started_rpe_assigned_submissions + not_started_scores
      }
    end

    def new
      respond_to do |f|
        f.html

        f.json {
          if (submission_id = FindEligibleSubmissionId.call(
            current_judge,
            {
              score_id: params[:score_id],
              team_submission_id: params[:team_submission_id]
            }
          ))

            submission = TeamSubmission.find(submission_id)
            questions = Questions.new(current_judge, submission)

            render json: questions
          else
            render json: {
              msg: "There are no more eligible submissions " \
                   "for you to judge now. This is not an error. " \
                   "Thank you for your contribution!"
            }, status: 404
          end
        }
      end
    end

    def show
      @score = current_judge.scores.find(params.fetch(:id))

      respond_to do |format|
        format.html { render "admin/scores/show" }
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

    def judge_recusal
      score = current_judge.submission_scores.find(params[:score_id])

      if score.update(score_params.merge({judge_recusal: true}))
        flash[:success] = "You have been sucessfully recused from this submission"
      else
        flash[:error] = "There was a problem, please try again"
      end

      head :ok, content_type: "text/json"
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

    def not_started_rpe_assigned_submissions
      teams = GatherAssignedTeams.call(current_judge)
      current_scores = current_judge.submission_scores.current_round

      teams
        .collect(&:submission)
        .select(&:complete?)
        .filter { |submission| current_scores.in_progress.pluck(:team_submission_id).exclude?(submission.id) }
        .filter { |submission| current_scores.complete.pluck(:team_submission_id).exclude?(submission.id) }
        .map do |submission|
        {
          id: submission.id,
          app_name: submission.app_name,
          team_name: submission.team_name,
          team_division: submission.team_division_name,
          judging_format: SubmissionScore::RPE_JUDGING_DISPLAY_TEXT,

          new_score_url: new_judge_score_path(
            team_submission_id: submission.id
          )
        }
      end
    end

    def not_started_scores
      current_judge.scores.not_started
        .map do |score|
        {
          id: score.id,
          app_name: score.team_submission.app_name,
          team_name: score.team_submission.team_name,
          team_division: score.team_submission.team_division_name,
          judging_format: SubmissionScore::ONLINE_JUDGING_DISPLAY_TEXT,

          new_score_url: new_judge_score_path(
            score: score.id
          )
        }
      end
    end

    def score_params
      params.require(:submission_score).permit(
        :project_details_1,
        :project_details_comment,
        :project_details_comment_word_count,
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
        :pitch_3,
        :pitch_4,
        :pitch_5,
        :pitch_6,
        :pitch_7,
        :pitch_8,
        :pitch_comment,
        :pitch_comment_word_count,
        :demo_1,
        :demo_2,
        :demo_3,
        :demo_comment,
        :demo_comment_word_count,
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
        :clicked_pitch_video,
        :clicked_demo_video,
        :downloaded_source_code,
        :downloaded_business_plan,
        :judge_recusal_reason,
        :judge_recusal_comment
      )
    end
  end
end
