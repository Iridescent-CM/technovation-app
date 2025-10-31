module Judging
  module TwentyTwentySix
    class BeginnerQuestions
      def call
        [
          Question.new(
            idx: 1,
            section: "project_details",
            field: :project_details_1,
            worth: 5,
            text: %(
              Is our project description compelling and does it clearly state the problem and solution (maximum 100 words)?
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
              Do we show the viewer 1-2 key features of the project and explain how our project solves the problem for the users?
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
            idx: 1,
            section: "demo",
            submission_type: "",
            field: :demo_1,
            worth: 5,
            text: %(
              Do we show what app or Scratch project we built and what parts work successfully so far?
            )
          ),

          Question.new(
            idx: 2,
            section: "demo",
            submission_type: "",
            field: :demo_2,
            worth: 5,
            text: %(
              Do we explain how the app or Scratch project was tested with users, what feedback was given, and how it affected the features of the project?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: "",
            ai_usage: true,
            field: :demo_3,
            worth: 5,
            text: %(
              Do we explain the generative AI process we used in either coding or building an AI model for the project, including tools and prompts?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: "",
            ai_usage: false,
            field: :demo_3,
            worth: 5,
            text: %(
              Do we explain what machine learning training and/or actual coding we did for 1-2 important parts of our app (not login screen)?
            )
          ),

          Question.new(
            idx: 4,
            section: "demo",
            submission_type: "",
            field: :demo_4,
            worth: 5,
            text: %(
              Do we show what doesn’t work yet and/or share future technical features?
            )
          ),

          Question.new(
            idx: 1,
            section: "ideation",
            field: :ideation_1,
            worth: 5,
            text: %(
              Do we share what we learned and the challenges we overcame through a combination of words and pictures (e.g. screenshots, prototypes)?
              Do we share any technical sources used/remixed and/or our favorite technical resource?
            )
          ),

          Question.new(
            idx: 2,
            section: "ideation",
            field: :ideation_2,
            worth: 5,
            text: %(
               Do we explain what we learned about AI and how we used it in our project?
            )
          )
        ]
      end
    end
  end
end
