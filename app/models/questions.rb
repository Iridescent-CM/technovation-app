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
      ),

      Question.new(
        submission_score: submission_score,
        section: 'pitch',
        field: :problem_clearly_communicated,
        idx: 1,
        text: "The team clearly states the " +
              "problem they are solving.",
        worth: 5,
        score: submission_score.problem_clearly_communicated,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'pitch',
        field: :compelling_argument,
        idx: 2,
        text: "The team presents a convincing argument " +
              "to support their solution.",
        worth: 5,
        score: submission_score.compelling_argument,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'pitch',
        field: :passion_energy,
        idx: 3,
        text: "The team’s pitch has a storyline " +
              "and is well thought out.",
        worth: 5,
        score: submission_score.passion_energy,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'pitch',
        field: :pitch_specific,
        idx: 4,
        text: "The pitch is specific and to the point.",
        worth: 5,
        score: submission_score.pitch_specific,
      ),
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
