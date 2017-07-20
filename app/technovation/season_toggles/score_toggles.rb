require "season_toggles/boolean_toggler"

class SeasonToggles
  module ScoreToggles
    def self.included(base)
      base.extend BooleanToggler
      base.extend ClassMethods
    end

    module ClassMethods
      def display_scores=(value)
        store.set(:display_scores, with_bool_validation(value))
      end

      def display_scores?
        convert_to_bool(store.get(:display_scores))
      end
    end
  end
end
