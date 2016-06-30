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

  def test_seed_adds_expertise
    assert Expertise.count == 3
    assert Expertise.pluck(:name).include?("Science")
    assert Expertise.pluck(:name).include?("Engineering")
    assert Expertise.pluck(:name).include?("Project Management")
  end

  def test_seed_adds_season
    assert Season.count == 1
    assert Season.current.year == Time.current.year
  end

  def test_seed_adds_score_category
    assert ScoreCategory.count == 5
    names = ScoreCategory.pluck(:name)
    assert names.include?("Ideation")
    assert names.include?("Technical")
    assert names.include?("Entrepreneurship")
    assert names.include?("Subjective")
    assert names.include?("Bonus")
  end

  def test_seed_adds_score_question
    assert ScoreQuestion.count == 1
    assert ScoreCategory.find_by(name: "Ideation").score_questions.last.label ==(
      "Did the team identify a real problem in their community?"
    )
  end

  def test_seed_adds_score_value
    assert ScoreValue.count == 2
    score_category = ScoreCategory.find_by(name: "Ideation")
    assert score_category.is_expertise?
    assert score_category.score_questions.first
                         .score_values.first.label == "No"
    assert score_category.score_questions.first
                         .score_values.first.value.zero?

    assert score_category.score_questions.last
                         .score_values.last.label == "Yes"
    assert score_category.score_questions.last
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
    assert JudgeProfile.count == 1
  end

  def test_seed_adds_student
    assert StudentProfile.count == 1
  end

  def test_seed_adds_mentor
    assert Mentor.count == 1
  end

  def test_seed_adds_admin
    assert AdminProfile.count == 1
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
