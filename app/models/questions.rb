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
      ideation
      technical
    ]

    if submission.senior_division?
      collection << "entrepreneurship"
    end

    collection + %w[
      pitch
      overall
    ]
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
        }
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

    [
      Question.new(
        section: "ideation",
        field: :ideation_1,
        idx: 1,
        text: %(
          Did we demonstrate the problem we chose is important, and use
          statistics, facts and personal stories to show its impact on
          us and our community or the world?
        ),
        worth: 5,
        score: submission_score.ideation_1
      ),

      Question.new(
        section: "ideation",
        field: :ideation_2,
        idx: 2,
        text: %(
          Will our app help solve a
          <a href="https://sdgs.un.org/goals" class="font-weight--bold" target="_blank">UN SDG</a>
          and positively impact direct and
          indirect users? Did we conduct solid user research?
        ),
        worth: 5,
        score: submission_score.ideation_2
      ),

      Question.new(
        section: "ideation",
        field: :ideation_3,
        idx: 3,
        text: %(
          Do you agree that our app is innovative (a fundamentally
          new solution/use of mobile app technology or an innovative
          application of an existing structure to a new situation)?
        ),
        worth: 5,
        score: submission_score.ideation_3
      ),

      Question.new(
        section: "ideation",
        field: :ideation_4,
        idx: 4,
        text: %(
          Do you see evidence that our app or idea was improved or
          changed in response to competitor research?
        ),
        worth: 5,
        score: submission_score.ideation_4
      ),

      Question.new(
        section: "technical",
        field: :technical_1,
        idx: 1,
        text: %(
          Do we show that our app is fully functional in the Demo Video
          or by launching it in an app store?
        ),
        worth: 5,
        score: submission_score.technical_1
      ),

      Question.new(
        section: "technical",
        field: :technical_2,
        idx: 2,
        text: %(
          Do we demonstrate how we developed our app for our target
          audience, tested it with them, and made sure it was easy to
          use?
        ),
        worth: 5,
        score: submission_score.technical_2
      ),

      Question.new(
        section: "technical",
        field: :technical_3,
        idx: 3,
        text: "Are you able to see what our team learned about coding?",
        worth: 5,
        score: submission_score.technical_3
      ),

      Question.new(
        section: "technical",
        field: :technical_4,
        idx: 4,
        text: %(
          Does our code include advanced functions such as using a
          database with APIs and/or using more than 1 sensor, phone
          function, or different technology (like AI, VR or hardware)?
        ),

        worth: 5,
        score: submission_score.technical_4
      ),

      Question.new(
        section: "pitch",
        field: :pitch_1,
        idx: 1,
        text: %(
          Does our pitch video convey the urgency of our problem and
          solution in a creative and engaging way?
        ),
        worth: 5,
        score: submission_score.pitch_1
      ),

      Question.new(
        section: "pitch",
        field: :pitch_2,
        idx: 2,
        text: %(
          Do you see evidence of our team sharing our journey, including
          challenges we encountered and how we grew?
        ),
        worth: 5,
        score: submission_score.pitch_2
      ),

      Question.new(
        section: "entrepreneurship",
        field: :entrepreneurship_1,
        idx: 1,
        text: %(
          How clearly has our team defined our goals, planned to reach
          target users, and integrated feedback from initial marketing
          attempts into our plan?
        ),
        worth: 5,
        score: submission_score.entrepreneurship_1
      ),

      Question.new(
        section: "entrepreneurship",
        field: :entrepreneurship_2,
        idx: 2,
        text: %(
          How realistic and thorough do you find our financial plan to
          be, and is it supported by budgets and research?
        ),
        worth: 5,
        score: submission_score.entrepreneurship_2
      ),

      Question.new(
        section: "entrepreneurship",
        field: :entrepreneurship_3,
        idx: 3,
        text: %(
          How cohesive and realistic do find our business plan? Does
          it include logical company, product or service descriptions,
          market analysis, and graphics?
        ),
        worth: 5,
        score: submission_score.entrepreneurship_3
      ),

      Question.new(
        section: "entrepreneurship",
        field: :entrepreneurship_4,
        idx: 4,
        text: "Do you believe our branding is clear and amplifies our team's purpose?",
        worth: 5,
        score: submission_score.entrepreneurship_4
      ),

      Question.new(
        section: "overall",
        field: :overall_1,
        idx: 1,
        text: "Are our team's proposed plan and goals to continue working on our app realistic?",
        worth: 5,
        score: submission_score.overall_1
      ),

      Question.new(
        section: "overall",
        field: :overall_2,
        idx: 2,
        text: "How well do you think our solution is thought out and can succeed?",
        worth: 5,
        score: submission_score.overall_2
      )
    ]
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
