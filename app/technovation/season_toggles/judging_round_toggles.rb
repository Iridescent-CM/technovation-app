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
        Date.new(Season.current.year, 6, 1)
      end

      def live_judge_qf_deadline
        DateTime.new(Season.current.year, 5, 22, 0, 0, 0)
      end

      def virtual_judge_qf_deadline
        DateTime.new(Season.current.year, 5, 20, 0, 0, 0)
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
          "May 22<sup>nd</sup> (US/Pacific time)".html_safe
        elsif quarterfinals?
          "May 20<sup>th</sup> (US/Pacific time)".html_safe
        elsif semifinals?
          "June 17<sup>th</sup> (US/Pacific time)".html_safe
        else
          "- judging is closed -"
        end
      end

      def between_rounds?(judge)
        return false if judging_enabled?

        if LiveEventJudgingEnabled.(judge)
          Time.current > live_judge_qf_deadline &&
            Time.current < sf_opening_date
        else
          Time.current > virtual_judge_qf_deadline &&
            Time.current < sf_opening_date
        end
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
