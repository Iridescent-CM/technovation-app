require "rails_helper"

class SeedsTest < Minitest::Test
  def setup
    Rails.application.load_tasks
    capture_stdout { Rake.application["db:seed"].invoke }
  end

  def teardown
    Rake::Task.clear
  end

  def test_seed_adds_region
    assert Region.count == 1
    assert Region.last.name == "US/Canada"
  end

  def test_seed_adds_season
    assert Season.count == 1
    assert Season.current.year == Time.current.year
  end

  def test_seed_adds_score_category
    assert ScoreCategory.count == 1
    assert ScoreCategory.last.name == "Ideation"
  end

  def test_seed_adds_score_attribute
    assert ScoreAttribute.count == 1
    assert ScoreCategory.last.score_attributes.last.label ==(
      "Did the team identify a real problem in their community?"
    )
  end

  def test_seed_adds_score_value
    assert ScoreValue.count == 2
    assert ScoreCategory.last.score_attributes.first
                        .score_values.first.label == "No"
    assert ScoreCategory.last.score_attributes.first
                        .score_values.first.value.zero?

    assert ScoreCategory.last.score_attributes.last
                        .score_values.last.label == "Yes"
    assert ScoreCategory.last.score_attributes.last
                        .score_values.last.value == 3
  end

  def test_seed_adds_team
    assert Team.count == 1
    assert Team.last.name == "The Techno Girls"
  end

  def test_seed_adds_team_submission
    assert Team.last.submissions.count == 1
  end

  def test_seed_adds_judge
    assert User.count == 1
    assert UserRole.count == 1
    assert Authentication.count == 1
    assert User.last.judge?
  end

  private
  def capture_stdout
    s = StringIO.new
    oldstdout = $stdout
    $stdout = s
    yield
    s.string
  ensure
    $stdout = oldstdout
  end
end
