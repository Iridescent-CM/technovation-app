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

      Question.new(
        submission_score: submission_score,
        section: 'entrepreneurship',
        field: :viable_business_model,
        idx: 1,
        text: "The team has a strategy to bring the app to market.",
        worth: 5,
        score: submission_score.viable_business_model,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'entrepreneurship',
        field: :market_research,
        idx: 2,
        text: "The team’s research shows they have looked for " +
              "competitors and ways to stand out from them.",
        worth: 5,
        score: submission_score.market_research,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'entrepreneurship',
        field: :business_plan_feasible,
        idx: 3,
        text: "The team has research on how they will sustain their " +
              "business. The goals are explained and realistic.",
        worth: 5,
        score: submission_score.business_plan_feasible,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'entrepreneurship',
        field: :business_plan_short_term,
        idx: 4,
        text: "The team’s business has an identity " +
              "through branding and visuals.",
        worth: 5,
        score: submission_score.business_plan_short_term,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'overall',
        field: :business_plan_long_term,
        idx: 1,
        text: "You are convinced the app can succeed.",
        worth: 5,
        score: submission_score.business_plan_long_term,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'overall',
        field: :submission_thought_out,
        idx: 2,
        text: "Each component of the team submission " +
              "is well thought out.",
        worth: 5,
        score: submission_score.submission_thought_out,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'overall',
        field: :cohesive_story,
        idx: 3,
        text: "The team’s strong dedication and work ethic is clear, " +
              "even if the submission is not complete.",
        worth: 5,
        score: submission_score.cohesive_story,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'overall',
        field: :solution_originality,
        idx: 4,
        text: "The way the team approaches and solves " +
              "the problem is unique.",
        worth: 5,
        score: submission_score.solution_originality,
      ),

      Question.new(
        submission_score: submission_score,
        section: 'overall',
        field: :solution_stands_out,
        idx: 5,
        text: "The submission stands out from others.",
        worth: 5,
        score: submission_score.solution_stands_out,
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
