class SeasonToggles
  extend BooleanToggler
  extend JudgingRoundToggler

  bool_blocked_by_judging :student_signup, topic: "Student signups"
  bool_blocked_by_judging :mentor_signup, topic: "Mentor signups"

  bool_blocked_by_judging :team_building_enabled, topic: "Team building"
  bool_blocked_by_judging :team_submissions_editable, topic: "Submissions"

  bool_blocked_by_judging :select_regional_pitch_event, topic: "Events"
  bool_blocked_by_judging :display_scores, topic: "Scores"

  class << self
    def configure(attrs)
      Hash(attrs).each { |k, v| send("#{k}=", v) }
    end

    %w{mentor student}.each do |scope|
      define_method("#{scope}_survey_link=") do |attrs|
        attrs = attrs.with_indifferent_access
        changed = %w{text url}.any? do |key|
          not attrs[key] == survey_link(scope, key)
        end

        if changed
          attrs[:changed_at] = Time.current
          store.set("#{scope}_survey_link", JSON.generate(attrs.to_h))
        end
      end
    end

    def survey_link_available?(scope)
      %w{text url changed_at}.all? do |key|
        !!survey_link(scope, key) and not survey_link(scope, key).empty?
      end
    end

    def show_survey_link_modal?(scope, last_shown)
      survey_link_available?(scope) and
        not survey_link(scope, "changed_at") == last_shown
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

    private
    def store
      @@store ||= Redis.new
    end
  end

  class InvalidInput < StandardError; end
end
