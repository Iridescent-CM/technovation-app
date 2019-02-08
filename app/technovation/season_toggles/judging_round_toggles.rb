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
      def sf_opening_date
        ImportantDates.semifinals_judging_begins
      end

      def live_judge_qf_deadline
        ImportantDates.live_quarterfinals_judging_ends
      end

      def virtual_judge_qf_deadline
        ImportantDates.virtual_quarterfinals_judging_ends
      end

      def judging_round=(value)
        store.set(:judging_round, with_judging_round_validation(value))
      end

      def judging_round(opts = {})
        round = store.get(:judging_round) || :off

        if !!opts[:full_name]
          case round
          when 'qf'; 'quarterfinals'
          when 'sf'; 'semifinals'
          else;      round
          end
        else
          round
        end
      end
      alias :current_judging_round :judging_round

      def current_round_deadline(judge)
        if LiveEventJudgingEnabled.(judge)
          ImportantDates.live_quarterfinals_judging_ends
            .strftime("%B %-d (US/Pacific time)").html_safe
        elsif quarterfinals?
          ImportantDates.virtual_quarterfinals_judging_ends
            .strftime("%B %-d (US/Pacific time)").html_safe
        elsif semifinals?
          ImportantDates.semifinals_judging_ends
            .strftime("%B %-d (US/Pacific time)").html_safe
        else
          "- judging is closed -"
        end
      end

      def between_rounds?(judge)
        return false if judging_enabled?

        if judge && LiveEventJudgingEnabled.(judge)
          Time.current > live_judge_qf_deadline &&
            Time.current < sf_opening_date
        else
          Time.current > virtual_judge_qf_deadline &&
            Time.current < sf_opening_date
        end
      end

      def judging_enabled_or_between?
        judging_enabled? || between_rounds?(nil)
      end

      def quarterfinals_or_earlier?(judge)
        return true if quarterfinals?

        if LiveEventJudgingEnabled.(judge)
          Time.current <= live_judge_qf_deadline
        else
          Time.current <= virtual_judge_qf_deadline
        end
      end

      def pitch_presentation_needed?(team)
        Time.current <= live_judge_qf_deadline &&
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

      def judging_enabled_for?(judge)
        if quarterfinals_judging?
          if LiveEventJudgingEnabled.(judge)
            Time.current <= live_judge_qf_deadline
          else
            Time.current <= virtual_judge_qf_deadline
          end
        else
          semifinals_judging?
        end
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
