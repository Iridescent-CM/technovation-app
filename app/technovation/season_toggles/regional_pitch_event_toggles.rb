require "season_toggles/boolean_toggler"
require "season_toggles/judging_round_dependency"

class SeasonToggles
  module RegionalPitchEventToggles
    def self.included(base)
      base.extend BooleanToggler
      base.extend ClassMethods

      base.extend JudgingRoundDependency
      base.judging_must_be_off :select_regional_pitch_event,
        topic: "Event selection"
    end

    module ClassMethods
      def select_regional_pitch_event=(value)
        store.set(:select_regional_pitch_event, with_bool_validation(value))
      end

      def select_regional_pitch_event?
        convert_to_bool(store.get(:select_regional_pitch_event))
      end
    end
  end
end
