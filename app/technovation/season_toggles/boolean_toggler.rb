class SeasonToggles
  module BooleanToggler
    private
    def with_bool_validation(value)
      if VALID_BOOLS.include?(value.to_s.downcase)
        value.to_s.downcase
      else
        raise_invalid_input_error(actual: value, expected: VALID_BOOLS.join(' | '))
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
end
