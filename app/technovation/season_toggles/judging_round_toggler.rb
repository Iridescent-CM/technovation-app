require "season_toggles/boolean_toggler"

class SeasonToggles
  module JudgingRoundToggler
    def self.extended(base)
      base.extend BooleanToggler
    end

    VALID_QF_JUDGING_ROUNDS = %w{qf quarter_finals quarterfinals}
    VALID_SF_JUDGING_ROUNDS = %w{sf semi_finals semifinals}
    VALID_JUDGING_ROUNDS = VALID_QF_JUDGING_ROUNDS +
                           VALID_SF_JUDGING_ROUNDS +
                           %w{off}

    @@blocked_by_judging_keys = []
    @@blocked_by_judging_topics = []

    def judging_round=(value)
      store.set(:judging_round, with_judging_round_validation(value))

      if value.to_s.downcase != "off"
        warn_about_judging_enabled

        @@blocked_by_judging_keys.each do |method|
          self.send("#{method}=", false)
        end
      end
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

    def bool_blocked_by_judging(key, options = {})
      @@blocked_by_judging_keys << key
      @@blocked_by_judging_topics << options[:topic]

      define_singleton_method("#{key}=") do |value|
        if judging_enabled?
          if convert_to_bool(value)
            warn_about_judging_enabled(options[:topic])
          end

          store.set(key, false)
        else
          store.set(key, with_bool_validation(value))
        end
      end

      define_singleton_method("#{key}?") do
        not judging_enabled? and convert_to_bool(store.get(key))
      end
    end

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

    def warn_about_judging_enabled(topic = nil)
      unless Rails.env.test?
        topic ||= @@blocked_by_judging_topics.join(", ")
        warn("JUDGING IS ENABLED: Setting #{topic} to FALSE")
      end
    end
  end
end
