module Judging
  module TwentyTwentySix
    class SeniorQuestions
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
              Does our pitch video clearly state the problem and show why the problem is
              important to us and our community and which United Nations Sustainable Development Goals are addressed?
            )
          ),

          Question.new(
            idx: 2,
            section: "pitch",
            field: :pitch_2,
            worth: 5,
            text: %(
              Do we explain how we researched the complexity of the problem?
            )
          ),

          Question.new(
            idx: 3,
            section: "pitch",
            field: :pitch_3,
            worth: 5,
            text: %(
              Do we show the viewer 1-2 key features of the project and explain how
              our project solves the problem for the users?
            )
          ),

          Question.new(
            idx: 4,
            section: "pitch",
            field: :pitch_4,
            worth: 5,
            text: %(
              Do we explain how the selected technology is the best solution compared to what already exists?
            )
          ),

          Question.new(
            idx: 5,
            section: "pitch",
            field: :pitch_5,
            worth: 5,
            text: %(
              Do we explain how we considered the ethics of our solution to make sure the solution will
              only have a positive impact on direct or indirect users and the planet?
            )
          ),

          Question.new(
            idx: 1,
            section: "demo",
            submission_type: "",
            field: :demo_1,
            worth: 5,
            text: %(
              Do we show the working parts of the app we built?
            )
          ),

          Question.new(
            idx: 2,
            section: "demo",
            submission_type: "",
            field: :demo_2,
            worth: 5,
            text: %(
              Do we explain how the app was tested with users, what feedback was given, and how it affected the features of the app?
            )
          ),

          Question.new(
            idx: 3,
            section: "demo",
            submission_type: "",
            field: :demo_3,
            worth: 5,
            text: %(
              Do we explain the machine learning training and/or actual coding we did for 1 or 2 important parts of our app, other than the login screen?
            )
          ),

          Question.new(
            idx: 4,
            section: "demo",
            submission_type: "",
            field: :demo_4,
            worth: 5,
            text: %(
              Do we show what doesn’t work yet and/or share future app features?
            )
          ),

          Question.new(
            idx: 1,
            section: "entrepreneurship",
            field: :entrepreneurship_1,
            worth: 5,
            text: %(
              Do we clearly explain our company and product description in a
              well-written document accompanied by supporting graphics?
            )
          ),

          Question.new(
            idx: 2,
            section: "entrepreneurship",
            field: :entrepreneurship_2,
            worth: 5,
            text: %(
              Do we show what market research the team has conducted to
              identify target users and main competitors?
            )
          ),

          Question.new(
            idx: 3,
            section: "entrepreneurship",
            field: :entrepreneurship_3,
            worth: 5,
            text: %(
              Do we explain the marketing plan for how the team will get new users to use our app in its first year?
            )
          ),

          Question.new(
            idx: 4,
            section: "entrepreneurship",
            field: :entrepreneurship_4,
            worth: 5,
            text: %(
              Do we show financial plans for starting the business and explain why they are realistic?
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
              Do we explain what we learned about AI and how we used it in our project?
            )
          ),

          Question.new(
            idx: 3,
            section: "ideation",
            field: :ideation_3,
            worth: 5,
            text: %(
              Do we describe how we overcame technical or non-technical challenges?
            )
          )
        ]
      end
    end
  end
end
