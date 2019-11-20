class Questions
  include Rails.application.routes.url_helpers
  include Enumerable

  attr_reader :judge, :submission, :questions, :submission_score

  def initialize(judge, submission, options = {})
    @judge = judge
    @submission = submission
    @submission_score = options[:score]
    @questions = init_questions
  end

  def self.for(score)
    new(score.judge_profile, score.team_submission, score: score)
  end

  def each(&block)
    @questions.each { |q| block.call(q) }
  end

  def in_section(section_name)
    @questions.select do |question|
      String(question.section) === String(section_name)
    end
  end

  def sections
    collection = %w{
      ideation
      technical
    }

    if submission.senior_division?
      collection << 'entrepreneurship'
    end

    collection += %w{
      pitch
      overall
    }
  end

  def as_json(*args, &block)
    if submission.developed_on?("Thunkable")
      source_code_url_label = "Open this project in Thunkable"
      source_code_url = submission.thunkable_project_url
    else
      source_code_url_label = "Download the source code"
      source_code_url = submission.source_code_url
    end

    {
      score: {
        id: submission_score.id,
        comments: {
          ideation: comment_data(submission_score, :ideation),
          technical: comment_data(submission_score, :technical),
          pitch: comment_data(submission_score, :pitch),
          entrepreneurship: comment_data(
            submission_score,
            :entrepreneurship
          ),
          overall: comment_data(submission_score, :overall)
        },
      },

      submission: {
        id: submission.id,

        name: submission.app_name,
        description: simple_format(submission.app_description),

        development_platform: submission.development_platform_text,

        screenshots: submission.screenshots.map { |s|
          {
            id: s.id,
            thumb: s.image_url(:thumb),
            full: s.image_url(:large),
          }
        },

        pitch_video_id: submission.video_id(:pitch),
        pitch_video_url: judge_embed_code_path(submission, piece: :pitch),

        source_code_url_label: source_code_url_label,
        source_code_url: source_code_url,

        business_plan_url: submission.business_plan_url,
        pitch_presentation_url: submission.pitch_presentation_url,

        total_checklist_points: submission.total_technical_checklist,

        code_checklist: {
          technical: submission.code_checklist.technical.map { |item|
            { label: item.label, explanation: item.explanation }
          },
          database: submission.code_checklist.database.map { |item|
            { label: item.label, explanation: item.explanation }
          },
          mobile: submission.code_checklist.mobile.map { |item|
            { label: item.label, explanation: item.explanation }
          },
          process: submission.code_checklist.process.map { |item|
            { label: item.label, display: item.display }
          }
        },
      },

      team: {
        id: submission.team_id,
        name: submission.team_name,
        division: submission.team_division_name,
        location: submission.team_primary_location,
        photo: submission.team_photo_url,
        live_event: submission.team.live_event?,
      },

      questions: questions,
    }
  end

  private
  def init_questions
    @submission_score ||= init_db_score

    [
      Question.new(
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
        section: 'ideation',
        field: :evidence_of_problem,
        idx: 2,
        text: "The team provides evidence of the problem they are " +
              "solving through facts and statistics.",
        worth: 5,
        score: submission_score.evidence_of_problem,
      ),

      Question.new(
        section: 'ideation',
        field: :problem_addressed,
        idx: 3,
        text: "The team addresses the problem well.",
        worth: 5,
        score: submission_score.problem_addressed,
      ),

      Question.new(
        section: 'technical',
        field: :app_functional,
        idx: 1,
        text: "The app appears to be fully functional " +
              "and has no noticeable bugs.",
        worth: 5,
        score: submission_score.app_functional,
      ),

      Question.new(
        section: 'technical',
        field: :demo_video,
        idx: 2,
        text: "The app is easy to use and the " +
              "features are well thought out.",
        worth: 5,
        score: submission_score.demo_video,
      ),

      Question.new(
        section: 'pitch',
        field: :problem_clearly_communicated,
        idx: 1,
        text: "The team clearly states the " +
              "problem they are solving.",
        worth: 5,
        score: submission_score.problem_clearly_communicated,
      ),

      Question.new(
        section: 'pitch',
        field: :compelling_argument,
        idx: 2,
        text: "The team presents a convincing argument " +
              "to support their solution.",
        worth: 5,
        score: submission_score.compelling_argument,
      ),

      Question.new(
        section: 'pitch',
        field: :passion_energy,
        idx: 3,
        text: "The team’s pitch has a storyline " +
              "and is well thought out.",
        worth: 5,
        score: submission_score.passion_energy,
      ),

      Question.new(
        section: 'pitch',
        field: :pitch_specific,
        idx: 4,
        text: "The pitch is specific and to the point.",
        worth: 5,
        score: submission_score.pitch_specific,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :viable_business_model,
        idx: 1,
        text: "The team has a strategy to bring the app to market.",
        worth: 5,
        score: submission_score.viable_business_model,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :market_research,
        idx: 2,
        text: "The team’s research shows they have looked for " +
              "competitors and ways to stand out from them.",
        worth: 5,
        score: submission_score.market_research,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :business_plan_long_term,
        idx: 3,
        text: "The team has research on how they will sustain their " +
              "business. The goals are explained and realistic.",
        worth: 5,
        score: submission_score.business_plan_long_term,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :business_plan_short_term,
        idx: 4,
        text: "The team’s business has an identity " +
              "through branding and visuals.",
        worth: 5,
        score: submission_score.business_plan_short_term,
      ),

      Question.new(
        section: 'overall',
        field: :business_plan_feasible,
        idx: 1,
        text: "You are convinced the app can succeed.",
        worth: 5,
        score: submission_score.business_plan_feasible,
      ),

      Question.new(
        section: 'overall',
        field: :submission_thought_out,
        idx: 2,
        text: "Each component of the team submission " +
              "is well thought out.",
        worth: 5,
        score: submission_score.submission_thought_out,
      ),

      Question.new(
        section: 'overall',
        field: :cohesive_story,
        idx: 3,
        text: "The team’s strong dedication and work ethic is clear, " +
              "even if the submission is not complete.",
        worth: 5,
        score: submission_score.cohesive_story,
      ),

      Question.new(
        section: 'overall',
        field: :solution_originality,
        idx: 4,
        text: "The way the team approaches and solves " +
              "the problem is unique.",
        worth: 5,
        score: submission_score.solution_originality,
      ),

      Question.new(
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
    @submission_score ||= SubmissionScore.find_or_create_by!({
      team_submission: submission,
      judge_profile: judge,
      seasons: [Season.current.year],
      round: SeasonToggles.judging_round(full_name: true),
    })
  end

  def simple_format(text)
    if !!text
      paragraphs = text.split("\r\n")
      formatted = "<p>" + paragraphs.join("</p><p>") + "</p>"
      formatted.gsub("<p></p>", "")
    else
      ""
    end
  end

  def comment_data(score, section_name)
    {
      text: score["#{section_name}_comment"],
      word_count: score["#{section_name}_comment_word_count"],
    }
  end
end
