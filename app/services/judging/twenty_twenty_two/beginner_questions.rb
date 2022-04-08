module Judging
  module TwentyTwentyTwo
    class BeginnerQuestions
      def call
        [
          Question.new(
            idx: 1,
            section: "overview",
            field: :overview_1,
            worth: 3,
            text: %(
              Is our project name and 100 word problem/project description clear and compelling?
            )
          ),

          Question.new(
            idx: 1,
            section: "ideation",
            field: :ideation_1,
            worth: 3,
            text: %(
              Do we share what we learned through a combination of
              words and pictures (e.g. screenshots, prototypes)?
            )
          ),

          Question.new(
            idx: 2,
            section: "ideation",
            field: :ideation_2,
            worth: 3,
            text: %(
              Do we describe how we overcame challenges?
            )
          ),

          Question.new(
            idx: 1,
            section: "pitch",
            field: :pitch_1,
            worth: 3,
            text: %(
              Does our pitch video clearly state the problem and show why
              the problem is important to us and our community?
            )
          ),

          Question.new(
            idx: 2,
            section: "pitch",
            field: :pitch_2,
            worth: 3,
            text: %(
              Do we explain how our app or AI solution solves the problem for the users?
            )
          ),

          Question.new(
            idx: 3,
            section: "pitch",
            field: :pitch_3,
            worth: 3,
            text: %(
              Do we explain why the selected technology is the best tool to solve the problem?
            )
          ),

          Question.new(
            idx: 4,
            section: "pitch",
            field: :pitch_4,
            worth: 3,
            text: %(
              Do we show how it is a better solution to what already exists?
            )
          ),

          Question.new(
            idx: 5,
            section: "pitch",
            field: :pitch_5,
            worth: 3,
            text: %(
              Do we explain how we got user feedback on the problem and solution?
            )
          ),

          Question.new(
            idx: 6,
            section: "pitch",
            field: :pitch_6,
            worth: 3,
            text: %(
              Do we show how we made changes to the project based on user feedback?
            )
          ),

          Question.new(
            idx: 7,
            section: "pitch",
            field: :pitch_7,
            worth: 3,
            text: %(
              Do we explain future goals and plans for the project?
            )
          ),

          Question.new(
            idx: 1,
            section: "demo",
            submission_type: "mobile_app",
            field: :demo_1,
            worth: 3,
            text: %(
              Do we show what app we built and how it works?
            )
          ),

          Question.new(
            idx: 2,
            section: "demo",
            submission_type: "mobile_app",
            field: :demo_2,
            worth: 3,
            text: %(
              Do we show what works successfully and
              explain what coding was required to make it work?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: "mobile_app",
            field: :demo_3,
            worth: 3,
            text: %(
              Do we show what doesn’t work yet and/or shares future features?
            )
          ),

          Question.new(
            idx: 1,
            section: "demo",
            submission_type: "ai",
            field: :demo_1,
            worth: 3,
            text: %(
              Do we show what AI model we built and trained,
              including explaining what data we gathered and trained model with?
            )
          ),

          Question.new(
            idx: 2,
            section: "demo",
            submission_type: "ai",
            field: :demo_2,
            worth: 3,
            text: %(
              Do we show what invention we built or prototyped,
              explain how we built it, and how it works?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: "ai",
            field: :demo_3,
            worth: 3,
            text: %(
              Do we show what doesn’t work yet and/or shares future features?
            )
          )
        ]
      end
    end
  end
end
