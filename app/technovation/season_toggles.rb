class SeasonToggles
  VALID_TRUTHY = %w{on yes true}
  VALID_FALSEY = %w{off no false}
  VALID_BOOLS = VALID_TRUTHY + VALID_FALSEY

  VALID_QF_JUDGING_ROUNDS = %w{qf quarter_finals quarterfinals}
  VALID_SF_JUDGING_ROUNDS = %w{sf semi_finals semifinals}
  VALID_JUDGING_ROUNDS = VALID_QF_JUDGING_ROUNDS +
                           VALID_SF_JUDGING_ROUNDS +
                             %w{off}

  class << self
    %w{mentor student}.each do |scope|
      define_method("#{scope}_survey_link=") do |attrs|
        store.set("#{scope}_survey_link", JSON.generate(attrs))
      end

      define_method("#{scope}_survey_link") do
        value = store.get("#{scope}_survey_link") || "{}"
        JSON.parse(value)
      end

      define_method("#{scope}_survey_link?") do
        %w{text url}.all? do |key|
          !!public_send("#{scope}_survey_link")[key] and
            not public_send("#{scope}_survey_link")[key].empty?
        end
      end
    end

    def judging_round=(value)
      store.set(:judging_round, with_judging_round_validation(value))
    end

    def judging_round
      store.get(:judging_round)
    end
    alias :current_judging_round :judging_round

    def quarterfinals_judging?
      VALID_QF_JUDGING_ROUNDS.include?(judging_round)
    end
    alias :quarterfinals? :quarterfinals_judging?

    def semifinals_judging?
      VALID_SF_JUDGING_ROUNDS.include?(judging_round)
    end
    alias :semifinals? :semifinals_judging?

    %w{student mentor judge regional_ambassador}.each do |scope|
      define_method("#{scope}_signup=") do |value|
        store.set("#{scope}_signup", with_bool_validation(value))
      end

      define_method("#{scope}_signup?") do
        convert_to_bool(store.get("#{scope}_signup"))
      end
    end

    private
    def store
      @@store ||= Redis.new
    end

    def with_bool_validation(value)
      if VALID_BOOLS.include?(value.to_s.downcase)
        value.to_s.downcase
      else
        raise_invalid_input_error(actual: value, expected: VALID_BOOLS.join(' | '))
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

    def convert_to_bool(value)
      VALID_TRUTHY.include?(value)
    end

    def raise_invalid_input_error(options)
      raise InvalidInput,
        "No toggle exists for #{options[:actual]}. Use one of: #{options[:expected]}"
    end
  end

  class InvalidInput < StandardError; end
end
