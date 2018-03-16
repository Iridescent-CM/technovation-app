module Judge
  class ScoresController < JudgeController
    def new
      questions = Questions.new

      respond_to do |f|
        f.html { }
        f.json {
          render json: questions
        }
      end
    end

    class Questions
      include Enumerable

      attr_reader :questions

      def initialize
        @questions = init_questions
      end

      def each(&block)
        @questions.each { |q| block.call(q) }
      end

      private
      def init_questions
        [
          Question.new(
            section: 'ideation',
            idx: 1,
            text: "The team clearly shows how " +
                  "their app idea aligns " +
                  "with a problem in their community.",
            worth: 5,
            score: nil,
          ),

          Question.new(
            section: 'ideation',
            idx: 2,
            text: "The team provides evidence of the problem they are " +
                  "solving through facts and statistics.",
            worth: 5,
            score: nil,
          ),

          Question.new(
            section: 'ideation',
            idx: 3,
            text: "The team addresses the problem well.",
            worth: 5,
            score: nil,
          ),

          Question.new(
            section: 'technical',
            idx: 1,
            text: "The app appears to be fully functional " +
                  "and has no noticeable",
            worth: 5,
            score: nil,
          ),

          Question.new(
            section: 'technical',
            idx: 2,
            text: "The app is easy to use and the " +
                  "features are well thought out.",
            worth: 5,
            score: nil,
          )
        ]
      end
    end

    class Question
      attr_reader :section, :idx, :text, :worth, :score

      def initialize(attrs)
        attrs.symbolize_keys!
        @section = attrs[:section]
        @idx = attrs[:idx]
        @text = attrs[:text]
        @worth = attrs[:worth]
        @score = attrs[:score]
      end
    end
  end
end
