require "rake"
require "rails_helper"

class SeedsTest < Minitest::Test
  def setup
    Rake::Task.clear
    Rails.application.load_tasks
    capture_stdout { Rake.application["db:seed"].invoke }
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

  def test_seed_adds_score_question
    assert ScoreQuestion.count == 1
    assert ScoreCategory.last.score_questions.last.label ==(
      "Did the team identify a real problem in their community?"
    )
  end

  def test_seed_adds_score_value
    assert ScoreValue.count == 2
    assert ScoreCategory.last.score_questions.first
                        .score_values.first.label == "No"
    assert ScoreCategory.last.score_questions.first
                        .score_values.first.value.zero?

    assert ScoreCategory.last.score_questions.last
                        .score_values.last.label == "Yes"
    assert ScoreCategory.last.score_questions.last
                        .score_values.last.value == 3
  end

  def test_seed_adds_teams
    names = Team.pluck(:name)
    assert names.include?("The Techno Girls")
    assert names.include?("Girl Power")
  end

  def test_seed_adds_team_submission
    assert Team.last.submissions.count == 1
  end

  def test_seed_adds_judge
    assert AuthenticationRole.pluck(:role_id).include?(Role.judge.id)
  end

  def test_seed_adds_admin
    assert AuthenticationRole.pluck(:role_id).include?(Role.admin.id)
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
