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
      with_proper_dependency_order(attrs) do |ordered_attrs|
        ordered_attrs.each { |k, v| send("#{k}=", v) }
      end
    end

    private
    def store
      @@store ||= Redis.new
    end

    def with_proper_dependency_order(attrs, &block)
      tmp_attrs = Hash(attrs).with_indifferent_access
      ordered_attrs = {}

      judging_value = tmp_attrs.delete(:judging_round)
      ordered_attrs[:judging_round] = judging_value
      ordered_attrs.merge!(tmp_attrs)

      block.call(ordered_attrs)
    end
  end

  class InvalidInput < StandardError; end
end
