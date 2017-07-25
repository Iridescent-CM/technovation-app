require "season_toggles/boolean_toggler"
require "season_toggles/judging_round_dependency"

class SeasonToggles
  module SignupToggles
    SCOPES = %w{
      student
      mentor
      judge
      regional_ambassador
    }

    def self.included(base)
      base.extend BooleanToggler
      base.extend ClassMethods

      base.extend JudgingRoundDependency
      base.judging_must_be_off :student_signup, topic: "Student signups"
      base.judging_must_be_off :mentor_signup, topic: "Mentor signups"
    end

    module ClassMethods
      SCOPES.each do |scope|
        define_method("#{scope}_signup=") do |value|
          store.set("#{scope}_signup", with_bool_validation(value))
        end

        define_method("#{scope}_signup?") do
          convert_to_bool(store.get("#{scope}_signup"))
        end
      end

      def registration_open?
        SCOPES.any? { |scope| signup_enabled?(scope) }
      end

      def registration_closed?
        SCOPES.all? { |scope| signup_disabled?(scope) }
      end

      def disable_signups!
        SCOPES.each { |scope| disable_signup(scope) }
      end

      def disable_signup(scope)
        send("#{scope}_signup=", false)
      end

      def enable_signup(scope)
        send("#{scope}_signup=", true)
      end

      def signup_enabled?(scope)
        send("#{scope}_signup?")
      end

      def signup_disabled?(scope)
        not signup_enabled?(scope)
      end
    end
  end
end
