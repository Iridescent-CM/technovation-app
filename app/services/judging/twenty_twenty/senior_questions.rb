module Judging
  module TwentyTwenty
    class SeniorQuestions
      def call
        [
          Question.new(
            idx: 1,
            section: "ideation",
            field: :ideation_1,
            worth: 5,
            text: %(
              Team has chosen an important problem and uses statistics,
              facts and personal stories to demonstrate its impact on them
              and/or their community.
            )
          ),

          Question.new(
            idx: 2,
            section: "ideation",
            field: :ideation_2,
            worth: 5,
            text: %(
              To ensure positive impact of solution, team has completed
              user research and adapted their idea based on community feedback.
            )
          ),

          Question.new(
            idx: 3,
            section: "ideation",
            field: :ideation_3,
            worth: 5,
            text: "Team presents a fundamentally new solution or use of mobile app technology."
          ),

          Question.new(
            idx: 4,
            section: "ideation",
            field: :ideation_4,
            worth: 5,
            text: "Team's app or idea was improved or changed in response to competitor research."
          ),

          Question.new(
            idx: 1,
            section: "technical",
            field: :technical_1,
            worth: 5,
            text: "App is fully functional and has no noticeable bugs."
          ),

          Question.new(
            idx: 2,
            section: "technical",
            field: :technical_2,
            worth: 5,
            text: %(
              Team provides examples of how they developed app for a target audience
              and shows evidence of testing and refinement.
            )
          ),

          Question.new(
            idx: 3,
            section: "technical",
            field: :technical_3,
            worth: 5,
            text: "All team members appear to have gained technical knowledge and contributed to coding."
          ),

          Question.new(
            idx: 4,
            section: "technical",
            field: :technical_4,
            worth: 5,
            text: %(
              Code includes advanced functions such as using a database with APIs
              and/or app uses more than 1 sensor, phone function, or different
              technology (like AI, VR or hardware).
            )
          ),

          Question.new(
            idx: 1,
            section: "pitch",
            field: :pitch_1,
            worth: 5,
            text: %(
              The pitch makes me believe that this is an urgent problem and that the
              team has an effective solution.
            )
          ),

          Question.new(
            idx: 2,
            section: "pitch",
            field: :pitch_2,
            worth: 5,
            text: %(
              The pitch makes me believe that the team learned from challenges and
              each girl persevered to learn new skills.
            )
          ),

          Question.new(
            idx: 1,
            section: "entrepreneurship",
            field: :entrepreneurship_1,
            worth: 5,
            text: %(
              Team has clear goals and plan to reach target users.
              They've integrated feedback from initial marketing attempts into this plan.
            )
          ),

          Question.new(
            idx: 2,
            section: "entrepreneurship",
            field: :entrepreneurship_2,
            worth: 5,
            text: %(
              Team has a financial plan supported by budgets and research for
              starting and sustaining the business.
            )
          ),

          Question.new(
            idx: 3,
            section: "entrepreneurship",
            field: :entrepreneurship_3,
            worth: 5,
            text: %(
              Business plan includes logical company, product or service descriptions,
              market analysis, and graphics.
            )
          ),

          Question.new(
            idx: 4,
            section: "entrepreneurship",
            field: :entrepreneurship_4,
            worth: 5,
            text: "Branding is clear and amplifies the team’s purpose."
          ),

          Question.new(
            idx: 1,
            section: "overall",
            field: :overall_1,
            worth: 5,
            text: "I believe this team will continue working to make their ideas a reality."
          ),

          Question.new(
            idx: 2,
            section: "overall",
            field: :overall_2,
            worth: 5,
            text: %(
              This solution will positively impact our world!
              The idea is well thought out and the app is developed.
            )
          )
        ]
      end
    end
  end
end
