module Judging
  module TwentyTwentyTwo
    class SeniorQuestions
      def call
        [
          Question.new(
            idx: 1,
            section: "overview",
            field: :overview_1,
            worth: 5,
            text: %(
              Is our project name and 100 word problem/project description clear and compelling?
            )
          ),

          Question.new(
            idx: 1,
            section: "ideation",
            field: :ideation_1,
            worth: 5,
            text: %(
              Do we share what we learned through a combination of
              words and pictures (e.g. screenshots, prototypes)?
            )
          ),

          Question.new(
            idx: 2,
            section: "ideation",
            field: :ideation_2,
            worth: 5,
            text: %(
              Do we describe how we overcame challenges?
            )
          ),

          Question.new(
            idx: 1,
            section: "pitch",
            field: :pitch_1,
            worth: 5,
            text: %(
              Does our pitch video clearly state the problem and show why
              the problem is important to us and our community?
            )
          ),

          Question.new(
            idx: 2,
            section: "pitch",
            field: :pitch_2,
            worth: 5,
            text: %(
              Do we explain what we researched about the problem and
              how it relates to the United Nations Sustainable Development Goals?
            )
          ),

          Question.new(
            idx: 3,
            section: "pitch",
            field: :pitch_3,
            worth: 5,
            text: %(
              Do we convince the viewer that the app or AI solution solves the problem for the users?
            )
          ),

          Question.new(
            idx: 4,
            section: "pitch",
            field: :pitch_4,
            worth: 5,
            text: %(
              Do we explain why the selected technology (AI prototype or mobile app)
              is the best tool to solve the problem?
            )
          ),

          Question.new(
            idx: 5,
            section: "pitch",
            field: :pitch_5,
            worth: 5,
            text: %(
              Do we show how it is a better solution compared to what already exists?
            )
          ),

          Question.new(
            idx: 6,
            section: "pitch",
            field: :pitch_6,
            worth: 5,
            text: %(
              Do we explain how we will make sure the solution will only have a
              positive impact on direct or indirect users and the planet?
            )
          ),

          Question.new(
            idx: 7,
            section: "pitch",
            field: :pitch_7,
            worth: 5,
            text: %(
              Do we explain user feedback on the problem and solution and
              show how we made changes based on the feedback?
            )
          ),

          Question.new(
            idx: 8,
            section: "pitch",
            field: :pitch_8,
            worth: 5,
            text: %(
              Do we explain future goals and plans for the project?
            )
          ),

          Question.new(
            idx: 1,
            section: "demo",
            submission_type: TeamSubmission::MOBILE_APP_SUBMISSION_TYPE,
            field: :demo_1,
            worth: 5,
            text: %(
              Do we show what app we built and how it works?
            )
          ),

          Question.new(
            idx: 2,
            section: "demo",
            submission_type: TeamSubmission::MOBILE_APP_SUBMISSION_TYPE,
            field: :demo_2,
            worth: 5,
            text: %(
              Do we show what works successfully and
              explain what coding was required to make it work?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: TeamSubmission::MOBILE_APP_SUBMISSION_TYPE,
            field: :demo_3,
            worth: 5,
            text: %(
              Do we show what doesn’t work yet and/or share future features?
            )
          ),

          Question.new(
            idx: 1,
            section: "demo",
            submission_type: TeamSubmission::AI_PROJECT_SUBMISSION_TYPE,
            field: :demo_1,
            worth: 5,
            text: %(
              Do we show what AI model we built and trained,
              including explaining what data we gathered and trained model with?
            )
          ),

          Question.new(
            idx: 2,
            section: "demo",
            submission_type: TeamSubmission::AI_PROJECT_SUBMISSION_TYPE,
            field: :demo_2,
            worth: 5,
            text: %(
              Do we show what invention we built or prototyped,
              explain how we built it, and show how it works?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: TeamSubmission::AI_PROJECT_SUBMISSION_TYPE,
            field: :demo_3,
            worth: 5,
            text: %(
              Do we show what doesn’t work yet and/or share future features?
            )
          ),

          Question.new(
            idx: 1,
            section: "entrepreneurship",
            field: :entrepreneurship_1,
            worth: 5,
            text: %(
              Do we clearly explain our company, product description,
              and relevant research accompanied by supporting graphics?
            )
          ),

          Question.new(
            idx: 2,
            section: "entrepreneurship",
            field: :entrepreneurship_2,
            worth: 5,
            text: %(
              Do we show how many users have already tested our
              app or invention, and the feedback provided?
            )
          ),

          Question.new(
            idx: 3,
            section: "entrepreneurship",
            field: :entrepreneurship_3,
            worth: 5,
            text: %(
              Do we explain how we will get new users to use their
              app or invention in its first year?
            )
          ),

          Question.new(
            idx: 4,
            section: "entrepreneurship",
            field: :entrepreneurship_4,
            worth: 5,
            text: %(
              Do we show realistic financial plans for starting and
              sustaining our business into the future?
            )
          )
        ]
      end
    end
  end
end
