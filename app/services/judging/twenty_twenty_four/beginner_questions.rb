module Judging
  module TwentyTwentyFour
    class BeginnerQuestions
      def call
        [
          Question.new(
            idx: 1,
            section: "project_details",
            field: :project_details_1,
            worth: 5,
            text: %(
              Is our 100 word problem/project description clear and compelling?
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
              Do we explain how our app or AI solution solves the problem for the users?
            )
          ),

          Question.new(
            idx: 3,
            section: "pitch",
            field: :pitch_3,
            worth: 5,
            text: %(
              Do we explain why the selected technology is the best tool to solve the problem?
            )
          ),

          Question.new(
            idx: 4,
            section: "pitch",
            field: :pitch_4,
            worth: 5,
            text: %(
              Do we show how it is a better solution to what already exists?
            )
          ),

          Question.new(
            idx: 5,
            section: "pitch",
            field: :pitch_5,
            worth: 5,
            text: %(
              Do we explain how we got user feedback on the problem and solution?
            )
          ),

          Question.new(
            idx: 6,
            section: "pitch",
            field: :pitch_6,
            worth: 5,
            text: %(
              Do we show how we made changes to the project based on user feedback?
            )
          ),

          Question.new(
            idx: 7,
            section: "pitch",
            field: :pitch_7,
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
              Do we show what app we built and what parts work successfully so far?
            )
          ),

          Question.new(
            idx: 2,
            section: "demo",
            submission_type: TeamSubmission::MOBILE_APP_SUBMISSION_TYPE,
            field: :demo_2,
            worth: 5,
            text: %(
              Do we explain the coding we did for 1 or 2 important parts of our app, other than the login screen?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: TeamSubmission::MOBILE_APP_SUBMISSION_TYPE,
            field: :demo_3,
            worth: 5,
            text: %(
              Do we show what doesn’t work yet and/or share future app features?
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
              Do we show the invention we built or prototyped?
              Do we explain how we built it? Do we show the parts that work?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: TeamSubmission::AI_PROJECT_SUBMISSION_TYPE,
            field: :demo_3,
            worth: 5,
            text: %(
              Do we show what doesn’t work yet and/or share future prototype features?
            )
          ),

          Question.new(
            idx: 1,
            section: "ideation",
            field: :ideation_1,
            worth: 5,
            text: %(
              Do we share what we learned through a combination of words and pictures (eg screenshots, prototypes)?
              Do we share any technical sources used/remixed and/or our favorite technical resource?
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
          )
        ]
      end
    end
  end
end
