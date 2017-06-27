require "active_model"

class SeasonToggles
  VALID_TRUTHY = %w{on yes true} + [true]
  VALID_FALSEY = %w{off no false} + [false]
  VALID_BOOLS = VALID_TRUTHY + VALID_FALSEY

  class << self
    def student_signup=(value)
      @@student_signup = convert_to_bool(value)
    end

    def student_signup?
      @@student_signup
    end

    private
    def convert_to_bool(value)
      if VALID_TRUTHY.include?(value)
        true
      elsif VALID_FALSEY.include?(value)
        false
      else
        raise InvalidInput, "Use one of: #{VALID_BOOLS}"
      end
    end
  end

  class InvalidInput < StandardError; end
end
