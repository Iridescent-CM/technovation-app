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
      base.judging_must_be_off :create_regional_pitch_event,
        topic: "Event creation"
    end

    module ClassMethods
      def select_regional_pitch_event=(value)
        store.set(
          :select_regional_pitch_event,
          with_bool_validation(value)
        )
      end

      def select_regional_pitch_event_on!
        self.select_regional_pitch_event = "on"
      end

      def select_regional_pitch_event_off!
        self.select_regional_pitch_event = "off"
      end

      def select_regional_pitch_event?
        convert_to_bool(store.get(:select_regional_pitch_event))
      end

      def events_disabled?
        !select_regional_pitch_event?
      end

      def create_regional_pitch_event=(value)
        store.set(
          :create_regional_pitch_event,
          with_bool_validation(value)
        )
      end

      def create_regional_pitch_event_on!
        self.create_regional_pitch_event = "on"
      end

      def create_regional_pitch_event_off!
        self.create_regional_pitch_event = "off"
      end

      def create_regional_pitch_event?
        convert_to_bool(store.get(:create_regional_pitch_event))
      end

      def add_teams_to_regional_pitch_event=(value)
        store.set(
          :add_teams_to_regional_pitch_event,
          with_bool_validation(value)
        )
      end

      def add_teams_to_regional_pitch_event_on!
        self.add_teams_to_regional_pitch_event = "on"
      end

      def add_teams_to_regional_pitch_event_off!
        self.add_teams_to_regional_pitch_event = "off"
      end

      def add_teams_to_regional_pitch_event?
        convert_to_bool(store.get(:add_teams_to_regional_pitch_event))
      end
    end
  end
end
