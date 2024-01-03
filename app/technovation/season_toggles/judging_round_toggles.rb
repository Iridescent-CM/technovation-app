require "season_toggles/boolean_toggler"

class SeasonToggles
  module JudgingRoundToggles
    def self.included(base)
      base.extend BooleanToggler
      base.extend ClassMethods
    end

    VALID_QF_JUDGING_ROUNDS = %w[qf quarter_finals quarterfinals]
    VALID_SF_JUDGING_ROUNDS = %w[sf semi_finals semifinals]
    VALID_JUDGING_ROUNDS = VALID_QF_JUDGING_ROUNDS +
      VALID_SF_JUDGING_ROUNDS +
      %w[off between finished]

    module ClassMethods
      def judging_round=(value)
        store.set(:judging_round, with_judging_round_validation(value))
      end

      def judging_round(opts = {})
        round = store.get(:judging_round) || :off

        if !!opts[:full_name]
          case round
          when "qf" then "quarterfinals"
          when "sf" then "semifinals"
          else; round
          end
        else
          round
        end
      end
      alias_method :current_judging_round, :judging_round

      def current_round_deadline(judge)
        if LiveEventJudgingEnabled.call(judge)
          ImportantDates.live_quarterfinals_judging_ends
            .strftime("%B %-d at 5pm (Pacific Daylight Time)").html_safe
        elsif quarterfinals?
          ImportantDates.virtual_quarterfinals_judging_ends
            .strftime("%B %-d at 5pm (Pacific Daylight Time)").html_safe
        elsif semifinals?
          ImportantDates.semifinals_judging_ends
            .strftime("%B %-d at 5pm (Pacific Daylight Time)").html_safe
        else
          "- judging is closed -"
        end
      end

      def judging_off?
        judging_round == "off"
      end
      alias_method :before_judging?, :judging_off?

      def between_rounds?
        judging_round == "between"
      end

      def judging_enabled_or_between?
        judging_enabled? || between_rounds?
      end

      def quarterfinals_or_earlier?
        true if quarterfinals? || before_judging?
      end

      def pitch_presentation_needed?(team)
        quarterfinals_or_earlier? &&
          !team_submissions_editable? &&
          team.live_event?
      end

      def set_judging_round(name)
        self.judging_round = name
      end

      def clear_judging_round
        self.judging_round = :off
      end

      def judging_round_off!
        clear_judging_round
      end

      def judging_enabled?
        quarterfinals_judging? or semifinals_judging?
      end

      def quarterfinals_judging?
        VALID_QF_JUDGING_ROUNDS.include?(judging_round)
      end
      alias_method :quarterfinals?, :quarterfinals_judging?

      def semifinals_judging?
        VALID_SF_JUDGING_ROUNDS.include?(judging_round)
      end
      alias_method :semifinals?, :semifinals_judging?

      def with_judging_round_validation(value)
        if VALID_JUDGING_ROUNDS.include?(value.to_s.downcase)
          value.to_s.downcase
        else
          raise_invalid_input_error(
            actual: value,
            expected: VALID_JUDGING_ROUNDS.join(" | ")
          )
        end
      end

      def judging_finished?
        judging_round == "finished"
      end
    end
  end
end
