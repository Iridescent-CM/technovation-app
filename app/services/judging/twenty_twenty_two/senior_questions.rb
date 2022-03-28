module Judging
  module TwentyTwentyTwo
    class SeniorQuestions
      def call
        [
          Question.new(
            idx: 1,
            section: "ideation",
            field: :ideation_1,
            worth: 5,
            text: %(
              Did we demonstrate the problem we chose is important, and use
              statistics, facts and personal stories to show its impact on
              us and our community or the world?
            )
          ),

          Question.new(
            idx: 2,
            section: "ideation",
            field: :ideation_2,
            worth: 5,
            text: %(
              Will our app help solve a
              <a href="https://sdgs.un.org/goals" class="font-weight--bold" target="_blank">UN SDG</a>
              and positively impact direct and
              indirect users? Did we conduct solid user research?
            )
          ),

          Question.new(
            idx: 3,
            section: "ideation",
            field: :ideation_3,
            worth: 5,
            text: %(
              Do you agree that our app is innovative (a fundamentally
              new solution/use of mobile app technology or an innovative
              application of an existing structure to a new situation)?
            )
          ),

          Question.new(
            idx: 4,
            section: "ideation",
            field: :ideation_4,
            worth: 5,
            text: %(
              Do you see evidence that our app or idea was improved or
              changed in response to competitor research?
            )
          ),

          Question.new(
            idx: 1,
            section: "technical",
            field: :technical_1,
            worth: 5,
            text: %(
              Do we show that our app is fully functional in the Demo Video
              or by launching it in an app store?
            )
          ),

          Question.new(
            idx: 2,
            section: "technical",
            field: :technical_2,
            worth: 5,
            text: %(
              Do we demonstrate how we developed our app for our target
              audience, tested it with them, and made sure it was easy to
              use?
            )
          ),

          Question.new(
            idx: 3,
            section: "technical",
            field: :technical_3,
            worth: 5,
            text: "Are you able to see what our team learned about coding?"
          ),

          Question.new(
            idx: 4,
            section: "technical",
            field: :technical_4,
            worth: 5,
            text: %(
              Does our code include advanced functions such as using a
              database with APIs and/or using more than 1 sensor, phone
              function, or different technology (like AI, VR or hardware)?
            )
          ),

          Question.new(
            idx: 1,
            section: "pitch",
            field: :pitch_1,
            worth: 5,
            text: %(
              Does our pitch video convey the urgency of our problem and
              solution in a creative and engaging way?
            )
          ),

          Question.new(
            idx: 2,
            section: "pitch",
            field: :pitch_2,
            worth: 5,
            text: %(
              Do you see evidence of our team sharing our journey, including
              challenges we encountered and how we grew?
            )
          ),

          Question.new(
            idx: 1,
            section: "entrepreneurship",
            field: :entrepreneurship_1,
            worth: 5,
            text: %(
              How clearly has our team defined our goals, planned to reach
              target users, and integrated feedback from initial marketing
              attempts into our plan?
            )
          ),

          Question.new(
            idx: 2,
            section: "entrepreneurship",
            field: :entrepreneurship_2,
            worth: 5,
            text: %(
              How realistic and thorough do you find our financial plan to
              be, and is it supported by budgets and research?
            )
          ),

          Question.new(
            idx: 3,
            section: "entrepreneurship",
            field: :entrepreneurship_3,
            worth: 5,
            text: %(
              How cohesive and realistic do find our business plan? Does
              it include logical company, product or service descriptions,
              market analysis, and graphics?
            )
          ),

          Question.new(
            idx: 4,
            section: "entrepreneurship",
            field: :entrepreneurship_4,
            worth: 5,
            text: "Do you believe our branding is clear and amplifies our team's purpose?"
          ),

          Question.new(
            idx: 1,
            section: "overall",
            field: :overall_1,
            worth: 5,
            text: "Are our team's proposed plan and goals to continue working on our app realistic?"
          ),

          Question.new(
            idx: 2,
            section: "overall",
            field: :overall_2,
            worth: 5,
            text: "How well do you think our solution is thought out and can succeed?"
          )
        ]
      end
    end
  end
end
