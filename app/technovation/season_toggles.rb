require "season_toggles/signup_toggles"
require "season_toggles/dashboard_notices"
require "season_toggles/survey_links"
require "season_toggles/team_toggles"
require "season_toggles/regional_pitch_event_toggles"
require "season_toggles/judging_round_toggles"
require "season_toggles/score_toggles"

class SeasonToggles
  include SignupToggles
  include DashboardNotices
  include SurveyLinks
  include TeamToggles
  include RegionalPitchEventToggles
  include JudgingRoundToggles
  include ScoreToggles

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
