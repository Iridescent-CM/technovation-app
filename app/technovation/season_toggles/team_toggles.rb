require "season_toggles/boolean_toggler"

class SeasonToggles
  module TeamToggles
    def self.included(base)
      base.extend ClassMethods
      base.extend BooleanToggler
    end

    module ClassMethods
      def team_building_enabled=(value)
        store.set(:team_building_enabled, with_bool_validation(value))
      end

      def team_building_enabled?
        convert_to_bool(store.get(:team_building_enabled))
      end

      def team_submissions_editable=(value)
        store.set(:team_submissions_editable, with_bool_validation(value))
      end

      def team_submissions_editable?
        convert_to_bool(store.get(:team_submissions_editable))
      end
    end
  end
end
