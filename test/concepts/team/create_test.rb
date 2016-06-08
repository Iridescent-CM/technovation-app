require "rails_helper"

class CreateTeamTest < Minitest::Test
  def test_team_registers_in_current_year
    Season::Create.(season: { year: Time.current.year, starts_at: Time.current })

    division = Division::CreateHighSchool.({}).model
    region = Region::Create.(region: { name: "US/Midwest" }).model

    team = Team::Create.(team: { name: "Great Team",
                                 description: "Just really great",
                                 division_id: division.id,
                                 region_id: region.id }).model

    assert team.seasons.current.year == Time.current.year
  end
end
