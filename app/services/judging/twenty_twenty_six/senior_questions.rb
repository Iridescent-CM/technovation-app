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
            idx: 2,
            section: "project_details",
            field: :project_details_2,
            worth: 5,
            text: %(
              Do we explain how we considered ethics in developing our app? Do we address one or more of the following aspects: data privacy, accessibility, energy consumption, impact on earth, bias and harm to particular groups?
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
              Do we explain some of the research we did to understand the problem?
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
              Do we talk about or include video footage of one or more target users providing feedback to us about our solution?
            )
          ),

          Question.new(
            idx: 6,
            section: "pitch",
            field: :pitch_6,
            worth: 5,
            text: %(
              Do we briefly explain our business model and financial plans to launch and maintain our company?
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
              Do we explain who the end users are and show how the app was tested with them?
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
              Do we describe our iterative development process through user feedback, testing, and (if applicable) AI prompt modification?
            )
          ),

          Question.new(
            idx: 1,
            section: "entrepreneurship",
            field: :entrepreneurship_1,
            worth: 5,
            text: %(
              Do we concisely explain the problem, solution, and business’ value proposition? Do we include how we integrated feedback or advice from a business professional or entrepreneur?
            )
          ),

          Question.new(
            idx: 2,
            section: "entrepreneurship",
            field: :entrepreneurship_2,
            worth: 5,
            text: %(
              Do we demonstrate thorough market research by clearly identifying competitors, defining the target market, and outlining strategies to reach and serve users?
            )
          ),

          Question.new(
            idx: 3,
            section: "entrepreneurship",
            field: :entrepreneurship_3,
            worth: 5,
            text: %(
              Do we demonstrate realistic company financial plans through cost structure and revenue streams?
            )
          ),

          Question.new(
            idx: 1,
            section: "ideation",
            field: :ideation_1,
            worth: 5,
            text: %(
              Do we share what we learned through a combination of words and pictures (eg screenshots, prototypes)? Do we include how we overcame technical or non-technical challenges?
            )
          ),

          Question.new(
            idx: 2,
            section: "ideation",
            field: :ideation_2,
            worth: 5,
            text: %(
              Do we explain how we decided what information we gathered was legitimate?
            )
          ),

          Question.new(
            idx: 3,
            section: "ideation",
            field: :ideation_3,
            worth: 5,
            text: %(
              Do we share a bibliography of resources used and/or remixed as part of the project, including the use of generative AI tools (if applicable)?
            )
          )
        ]
      end
    end
  end
end
