require "rails_helper"

class CreateSeasonRegistrationsTest < Minitest::Test
  def test_season_registation_defaults_to_current_season
    Season::Create.(season: { year: Time.current.year, starts_at: Time.current + 30.days })
    _, op = SeasonRegistration::Create.run(season_registration: { })
    assert op.contract.errors.instance_variable_get("@base").instance_variable_get("@fields")['season'].year == Time.current.year
  end
end
