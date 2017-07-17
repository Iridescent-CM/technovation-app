class SeasonToggles
  VALID_TRUTHY = %w{1 on yes true} + [true]
  VALID_FALSEY = %w{0 off no false} + [false]
  VALID_BOOLS = VALID_TRUTHY + VALID_FALSEY

  VALID_QF_JUDGING_ROUNDS = %w{qf quarter_finals quarterfinals}
  VALID_SF_JUDGING_ROUNDS = %w{sf semi_finals semifinals}
  VALID_JUDGING_ROUNDS = VALID_QF_JUDGING_ROUNDS +
                           VALID_SF_JUDGING_ROUNDS +
                             %w{off}

  class << self
    def configure(attrs)
      Hash(attrs).each { |k, v| send("#{k}=", v) }
    end

    def select_regional_pitch_event=(value)
      if judging_enabled?
        warn_about_judging_enabled("Events") if convert_to_bool(value)
        store.set(:select_regional_pitch_event, false)
      else
        store.set(:select_regional_pitch_event, with_bool_validation(value))
      end
    end

    def select_regional_pitch_event?
      not judging_enabled? and
        convert_to_bool(store.get(:select_regional_pitch_event))
    end

    def display_scores=(value)
      if judging_enabled?
        warn_about_judging_enabled("Scores") if convert_to_bool(value)
        store.set(:display_scores, false)
      else
        store.set(:display_scores, with_bool_validation(value))
      end
    end

    def display_scores?
      not judging_enabled? and
        convert_to_bool(store.get("display_scores"))
    end

    %w{mentor student}.each do |scope|
      define_method("#{scope}_survey_link=") do |attrs|
        attrs[:changed_at] = Time.current
        store.set("#{scope}_survey_link", JSON.generate(attrs.to_h))
      end
    end

    def survey_link_available?(scope)
      %w{text url changed_at}.all? do |key|
        !!survey_link(scope, key) and not survey_link(scope, key).empty?
      end
    end

    def show_survey_link_modal?(scope, last_shown)
      survey_link_available?(scope) and not survey_link(scope, "changed_at") == last_shown
    end

    def set_survey_link(scope, text, url)
      send("#{scope}_survey_link=", { text: text, url: url })
    end

    def survey_link(scope, key)
      value = store.get("#{scope}_survey_link") || "{}"
      parsed = JSON.parse(value)
      parsed[key.to_s]
    end

    %w{mentor student judge}.each do |scope|
      define_method("#{scope}_dashboard_text=") do |text|
        store.set("#{scope}_dashboard_text", text)
      end
    end

    def set_dashboard_text(scope, txt)
      send("#{scope}_dashboard_text=", txt)
    end

    def dashboard_text(scope)
      store.get("#{scope}_dashboard_text")
    end

    def team_submissions_editable=(value)
      if judging_enabled?
        warn_about_judging_enabled("Submissions") if convert_to_bool(value)
        store.set(:team_submissions_editable, false)
      else
        store.set(:team_submissions_editable, with_bool_validation(value))
      end
    end

    def team_submissions_editable?
      not judging_enabled? and
        convert_to_bool(store.get(:team_submissions_editable))
    end

    def team_building_enabled?
      return team_submissions_editable?
    end

    def judging_round=(value)
      store.set(:judging_round, with_judging_round_validation(value))

      if value.to_s.downcase != "off"
        warn_about_judging_enabled

        self.team_submissions_editable = false
        self.select_regional_pitch_event = false
        self.display_scores = false
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

    %w{student mentor judge regional_ambassador}.each do |scope|
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

    def warn_about_judging_enabled(topic = nil)
      unless Rails.env.test?
        topic ||= "submissions, event selection, and scores"
        warn("JUDGING IS ENABLED: Setting #{topic} to FALSE")
      end
    end
  end

  class InvalidInput < StandardError; end
end
