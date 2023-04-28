require "season_toggles/boolean_toggler"
require "season_toggles/judging_round_dependency"

class SeasonToggles
  module ScoreToggles
    def self.included(base)
      base.extend BooleanToggler
      base.extend ClassMethods

      base.extend JudgingRoundDependency
      base.judging_must_be_off :display_scores, topic: "Scores"
    end

    module ClassMethods
      def display_scores_on!
        self.display_scores = "on"
      end

      def display_scores_off!
        self.display_scores = "off"
      end

      def display_scores=(value)
        store.set(:display_scores, with_bool_validation(value))
      end

      def display_scores?
        convert_to_bool(store.get(:display_scores))
      end

      alias :display_scores_and_certs? :display_scores?

      def scores_disabled?
        not display_scores?
      end

      alias :display_scores_disabled? :scores_disabled?
    end
  end
end
