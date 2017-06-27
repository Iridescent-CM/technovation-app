class SeasonToggles
  VALID_TRUTHY = %w{on yes true} + [true]
  VALID_FALSEY = %w{off no false} + [false]
  VALID_BOOLS = VALID_TRUTHY + VALID_FALSEY

  class << self
    def student_signup=(value)
      store.set(:student_signup, with_bool_validation(value))
    end

    def student_signup?
      convert_to_bool(store.get(:student_signup))
    end

    private
    def store
      @@store ||= Redis.new
    end

    def with_bool_validation(value)
      if VALID_BOOLS.include?(value)
        value
      else
        raise InvalidInput, "Use one of: #{VALID_BOOLS}"
      end
    end

    def convert_to_bool(value)
      VALID_TRUTHY.include?(value)
    end
  end

  class InvalidInput < StandardError; end
end
