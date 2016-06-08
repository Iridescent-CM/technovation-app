require "rails_helper"

class SeasonCreateTest < Minitest::Test
  def test_season_requires_unique_year
    Season.create(year: 2000, starts_at: Time.current)
    season = Season.create(year: 2000)
    assert season.errors.keys.include?(:year)
    assert season.errors[:year].include?("has already been taken")
  end

  def test_season_requires_year
    season = Season.create(year: "")
    assert season.errors.keys.include?(:year)
    assert season.errors[:year].include?("can't be blank")
  end

  def test_season_requires_year_as_number
    season = Season.create(year: "hello")
    assert season.errors.keys.include?(:year)
    assert season.errors[:year].include?("is not a number")
  end

  def test_season_requires_starts_at
    season = Season.create(starts_at: "")
    assert season.errors.keys.include?(:starts_at)
    assert season.errors[:year].include?("can't be blank")
  end
end
