module Judge
  class ScoresController < JudgeController
    def new
      respond_to do |f|
        f.html { }
        f.json {
          submission_id = FindEligibleSubmissionId.(current_judge)
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
        :app_functional,
        :demo_video,
      )
    end

    class Questions
      include Enumerable

      attr_reader :judge, :submission, :questions

      def initialize(judge, submission)
        @judge = judge
        @submission = submission
        @questions = init_questions
      end

      def each(&block)
        @questions.each { |q| block.call(q) }
      end

      private
      def init_questions
        submission_score = init_db_score

        [
          Question.new(
            submission_score: submission_score,
            section: 'ideation',
            field: :sdg_alignment,
            idx: 1,
            text: "The team clearly shows how " +
                  "their app idea aligns " +
                  "with a problem in their community.",
            worth: 5,
            score: submission_score.sdg_alignment,
          ),

          Question.new(
            submission_score: submission_score,
            section: 'ideation',
            field: :evidence_of_problem,
            idx: 2,
            text: "The team provides evidence of the problem they are " +
                  "solving through facts and statistics.",
            worth: 5,
            score: submission_score.evidence_of_problem,
          ),

          Question.new(
            submission_score: submission_score,
            section: 'ideation',
            field: :problem_addressed,
            idx: 3,
            text: "The team addresses the problem well.",
            worth: 5,
            score: submission_score.problem_addressed,
          ),

          Question.new(
            submission_score: submission_score,
            section: 'technical',
            field: :app_functional,
            idx: 1,
            text: "The app appears to be fully functional " +
                  "and has no noticeable bugs",
            worth: 5,
            score: submission_score.app_functional,
          ),

          Question.new(
            submission_score: submission_score,
            section: 'technical',
            field: :demo_video,
            idx: 2,
            text: "The app is easy to use and the " +
                  "features are well thought out.",
            worth: 5,
            score: submission_score.demo_video,
          )
        ]
      end

      def init_db_score
        SubmissionScore.find_or_create_by!({
          team_submission: submission,
          judge_profile: judge,
          seasons: [Season.current.year],
        })
      end
    end

    class Question
      attr_reader :section, :idx, :text, :worth, :score, :update, :field

      def initialize(attrs)
        attrs.symbolize_keys!
        @section = attrs[:section]
        @idx = attrs[:idx]
        @text = attrs[:text]
        @worth = attrs[:worth]
        @score = attrs[:score]
        @field = attrs[:field]
        @update = "/judge/scores/#{attrs[:submission_score].id}"
      end
    end
  end
end
