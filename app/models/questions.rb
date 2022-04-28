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
    collection = %w[
      project_details
      ideation
      pitch
      demo
    ]

    if submission.senior_division? || submission.junior_division?
      collection << "entrepreneurship"
    end
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
        complete: submission_score.complete?,
        incomplete: submission_score.incomplete?,
        comments: {
          project_details: comment_data(submission_score, :project_details),
          ideation: comment_data(submission_score, :ideation),
          technical: comment_data(submission_score, :technical),
          pitch: comment_data(submission_score, :pitch),
          demo: comment_data(submission_score, :demo),
          entrepreneurship: comment_data(
            submission_score,
            :entrepreneurship
          ),
          overall: comment_data(submission_score, :overall)
        }
      },

      submission: {
        id: submission.id,

        name: submission.app_name,
        description: simple_format(submission.app_description),

        learning_journey: submission.learning_journey,

        development_platform: submission.development_platform_text,

        screenshots: submission.screenshots.map { |s|
          {
            id: s.id,
            thumb: s.image_url(:thumb),
            full: s.image_url(:large)
          }
        },

        demo_video_id: submission.video_id(:demo),
        demo_video_url: judge_embed_code_path(submission, piece: :demo),

        pitch_video_id: submission.video_id(:pitch),
        pitch_video_url: judge_embed_code_path(submission, piece: :pitch),

        source_code_url_label: source_code_url_label,
        source_code_url: source_code_url,

        business_plan_url: submission.business_plan_url,
        pitch_presentation_url: submission.pitch_presentation_url
      },

      team: {
        id: submission.team_id,
        name: submission.team_name,
        division: submission.team_division_name,
        location: submission.team_primary_location,
        photo: submission.team_photo_url,
        live_event: submission.team.live_event?
      },

      questions: questions
    }
  end

  private

  def init_questions
    @submission_score ||= init_db_score

    JudgeQuestionsForSubmissionScore.new(submission_score).call
  end

  def init_db_score
    @submission_score ||= SubmissionScore.find_or_create_by!({
      team_submission: submission,
      judge_profile: judge,
      seasons: [Season.current.year],
      round: SeasonToggles.judging_round(full_name: true)
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
      word_count: score["#{section_name}_comment_word_count"]
    }
  end
end
