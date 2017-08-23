require "season_toggles/boolean_toggler"
require "season_toggles/judging_round_dependency"

class SeasonToggles
  module TeamToggles
    def self.included(base)
      base.extend BooleanToggler
      base.extend JudgingRoundDependency
      base.extend ClassMethods

      base.judging_must_be_off :team_submissions_editable, topic: "Submissions"
      base.judging_must_be_off :team_building_enabled, topic: "Team building"
    end

    module ClassMethods
      def team_building_enabled=(value)
        store.set(:team_building_enabled, with_bool_validation(value))
      end

      def team_building_enabled?
        convert_to_bool(store.get(:team_building_enabled))
      end

      def team_building_enabled!
        self.team_building_enabled = true
      end

      def team_submissions_editable=(value)
        store.set(:team_submissions_editable, with_bool_validation(value))
      end

      def team_submissions_editable?
        convert_to_bool(store.get(:team_submissions_editable))
      end

      def team_submissions_editable!
        self.team_submissions_editable = true
      end
    end
  end
end
