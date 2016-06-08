require "rails_helper"

class RegisterationTest < Minitest::Test
  def test_register_in_current_season
    Season::Create.(season: { year: Time.current.year, starts_at: Time.current })

    region = Region::Create.(region: { name: "US/Midwest" }).model

    team = Team.create(name: "Great Team",
                       description: "Just really great",
                       division: Division.high_school,
                       region: region)

    SeasonRegistration.register(team)

    assert team.seasons.current.year == Time.current.year
  end
end
