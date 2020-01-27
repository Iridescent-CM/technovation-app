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
        field: :ideation_1,
        idx: 1,
        text: "Team has chosen an important problem and uses statistics, " +
              "facts and personal stories to demonstrate its impact on them " +
              "and/or their community.",
        worth: 5,
        score: submission_score.ideation_1,
      ),

      Question.new(
        section: 'ideation',
        field: :ideation_2,
        idx: 2,
        text: "To ensure positive impact of solution, team has completed " +
              "user research and adapted their idea based on community feedback.",
        worth: 5,
        score: submission_score.ideation_2,
      ),

      Question.new(
        section: 'ideation',
        field: :ideation_3,
        idx: 3,
        text: "Team presents a fundamentally new solution or use of mobile app technology.",
        worth: 5,
        score: submission_score.ideation_3,
      ),

      Question.new(
        section: 'ideation',
        field: :ideation_4,
        idx: 4,
        text: "Team's app or idea was improved or changed in response to competitor research.",
        worth: 5,
        score: submission_score.ideation_4,
      ),

      Question.new(
        section: 'technical',
        field: :technical_1,
        idx: 1,
        text: "App is fully functional and has no noticeable bugs.",
        worth: 5,
        score: submission_score.technical_1,
      ),

      Question.new(
        section: 'technical',
        field: :technical_2,
        idx: 2,
        text: "Team provides examples of how they developed app for a target audience " +
              "and shows evidence of testing and refinement.",
        worth: 5,
        score: submission_score.technical_2,
      ),

      Question.new(
        section: 'technical',
        field: :technical_3,
        idx: 3,
        text: "All team members appear to have gained technical knowledge and contributed to coding.",
        worth: 5,
        score: submission_score.technical_3,
      ),

      Question.new(
        section: 'technical',
        field: :technical_4,
        idx: 4,
        text: "Code includes advanced functions such as using a database with APIs " +
              "and/or app uses more than 1 sensor, phone function, or different " +
              "technology (like AI, VR or hardware).",
        worth: 5,
        score: submission_score.technical_4,
      ),

      Question.new(
        section: 'pitch',
        field: :pitch_1,
        idx: 1,
        text: "The pitch makes me believe that this is an urgent problem and that the " +
              "team has an effective solution.",
        worth: 5,
        score: submission_score.pitch_1,
      ),

      Question.new(
        section: 'pitch',
        field: :pitch_2,
        idx: 2,
        text: "The pitch makes me believe that the team learned from challenges and " +
              "each girl persevered to learn new skills.",
        worth: 5,
        score: submission_score.pitch_2,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :entrepreneurship_1,
        idx: 1,
        text: "Team has clear goals and plan to reach target users. They've " +
              "integrated feedback from initial marketing attempts into this plan.",
        worth: 5,
        score: submission_score.entrepreneurship_1,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :entrepreneurship_2,
        idx: 2,
        text: "Team has a financial plan supported by budgets and research for " +
              "starting and sustaining the business.",
        worth: 5,
        score: submission_score.entrepreneurship_2,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :entrepreneurship_3,
        idx: 3,
        text: "Business plan includes logical company, product or service descriptions, " +
              "market analysis, and graphics.",
        worth: 5,
        score: submission_score.entrepreneurship_3,
      ),

      Question.new(
        section: 'entrepreneurship',
        field: :entrepreneurship_4,
        idx: 4,
        text: "Branding is clear and amplifies the team’s purpose.",
        worth: 5,
        score: submission_score.entrepreneurship_4,
      ),

      Question.new(
        section: 'overall',
        field: :overall_1,
        idx: 1,
        text: "I believe this team will continue working to make their ideas a reality.",
        worth: 5,
        score: submission_score.overall_1,
      ),

      Question.new(
        section: 'overall',
        field: :overall_2,
        idx: 2,
        text: "This solution will positively impact our world! The idea is well thought out " +
              "and the app is developed.",
        worth: 5,
        score: submission_score.overall_2,
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
