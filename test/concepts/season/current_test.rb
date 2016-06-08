require "rails_helper"

class CurrentSeasonTest < Minitest::Test
  def test_finds_current_season
    Season::Create.(season: { year: Time.current.year - 1,
                              starts_at: Time.current - 1.year }).model
    this_year = Season::Create.(season: { year: Time.current.year,
                                          starts_at: Time.current }).model

    assert Season::Current.({}).model == this_year
  end
end
