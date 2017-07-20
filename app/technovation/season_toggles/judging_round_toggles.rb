require "season_toggles/boolean_toggler"

class SeasonToggles
  module JudgingRoundToggles
    def self.included(base)
      base.extend BooleanToggler
      base.extend ClassMethods
    end

    VALID_QF_JUDGING_ROUNDS = %w{qf quarter_finals quarterfinals}
    VALID_SF_JUDGING_ROUNDS = %w{sf semi_finals semifinals}
    VALID_JUDGING_ROUNDS = VALID_QF_JUDGING_ROUNDS +
                           VALID_SF_JUDGING_ROUNDS +
                           %w{off}

    module ClassMethods
      def judging_round=(value)
        store.set(:judging_round, with_judging_round_validation(value))
      end

      def judging_round
        store.get(:judging_round) || :off
      end
      alias :current_judging_round :judging_round

      def judging_enabled?
        quarterfinals_judging? or semifinals_judging?
      end

      def quarterfinals_judging?
        VALID_QF_JUDGING_ROUNDS.include?(judging_round)
      end
      alias :quarterfinals? :quarterfinals_judging?

      def semifinals_judging?
        VALID_SF_JUDGING_ROUNDS.include?(judging_round)
      end
      alias :semifinals? :semifinals_judging?

      def with_judging_round_validation(value)
        if VALID_JUDGING_ROUNDS.include?(value.to_s.downcase)
          value.to_s.downcase
        else
          raise_invalid_input_error(
            actual: value,
            expected: VALID_JUDGING_ROUNDS.join(' | ')
          )
        end
      end
    end
  end
end
