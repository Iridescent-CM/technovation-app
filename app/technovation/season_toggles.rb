require "season_toggles/signup_toggler"
require "season_toggles/dashboard_elements_toggler"
require "season_toggles/judging_round_toggler"

class SeasonToggles
  extend SignupToggler
  extend DashboardElementsToggler

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

    private
    def store
      @@store ||= Redis.new
    end
  end

  class InvalidInput < StandardError; end
end
