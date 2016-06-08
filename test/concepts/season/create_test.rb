require "rails_helper"

class SeasonCreateTest < Minitest::Test
  def test_season_persisted
    season = Season::Create.(season: { year: 2000, starts_at: Time.current }).model
    assert season.persisted?
  end

  def test_season_requires_unique_year
    Season::Create.(season: { year: 2000, starts_at: Time.current })
    _, op = Season::Create.run(season: { year: 2000 })
    assert op.contract.errors.keys.include?(:year)
    assert op.contract.errors[:year].include?("has already been taken")
  end

  def test_season_requires_year
    _, op = Season::Create.run(season: { year: "" })
    assert op.contract.errors.keys.include?(:year)
    assert op.contract.errors[:year].include?("can't be blank")
  end

  def test_season_requires_year_as_number
    _, op = Season::Create.run(season: { year: "hello" })
    assert op.contract.errors.keys.include?(:year)
    assert op.contract.errors[:year].include?("is not a number")
  end

  def test_season_requires_starts_at
    _, op = Season::Create.run(season: { starts_at: "" })
    assert op.contract.errors.keys.include?(:starts_at)
    assert op.contract.errors[:year].include?("can't be blank")
  end
end
