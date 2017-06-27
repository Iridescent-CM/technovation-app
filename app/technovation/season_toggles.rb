require "active_model"

class SeasonToggles
  VALID_BOOLS = %w{on off yes no true false} + [true, false]

  class << self
    def student_signup=(value)
      if VALID_BOOLS.include?(value)
        true
      else
        raise InvalidInput, "Use one of: #{VALID_BOOLS}"
      end
    end
  end

  class InvalidInput < StandardError; end
end
