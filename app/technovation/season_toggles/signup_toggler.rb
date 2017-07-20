class SeasonToggles
  module SignupToggler
    # student, mentor signups defined as
    # bool_blocked_by_judging singleton attrs

    %w{judge regional_ambassador}.each do |scope|
      define_method("#{scope}_signup=") do |value|
        store.set("#{scope}_signup", with_bool_validation(value))
      end

      define_method("#{scope}_signup?") do
        convert_to_bool(store.get("#{scope}_signup"))
      end
    end

    def disable_signup(scope)
      send("#{scope}_signup=", false)
    end

    def enable_signup(scope)
      send("#{scope}_signup=", true)
    end

    def signup_enabled?(scope)
      send("#{scope}_signup?")
    end
  end
end
