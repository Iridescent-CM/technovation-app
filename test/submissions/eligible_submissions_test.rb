require "rails_helper"

class EligibleSubmissionsTest < Minitest::Test
  def test_eligible_submission
    team = Team.create!(team_attributes)

    submission = Submission.create!({
      team: team,
      code: "code",
      demo: "demo",
      pitch: "pitch",
      description: "description"
    })

    assert submission.eligible?
  end

  def test_required_fields_include_code
    submission = Submission.new

    refute submission.eligible?
    assert submission.missing_fields.include?('code')

    submission.code = "something"
    refute submission.missing_fields.include?('code')
  end

  def test_required_fields_include_pitch
    submission = Submission.new

    refute submission.eligible?
    assert submission.missing_fields.include?('pitch')

    submission.pitch = "something"
    refute submission.missing_fields.include?('pitch')
  end

  def test_required_fields_include_description
    submission = Submission.new

    refute submission.eligible?
    assert submission.missing_fields.include?('description')

    submission.description = "something"
    refute submission.missing_fields.include?('description')
  end

  def test_required_fields_include_demo
    submission = Submission.new

    refute submission.eligible?
    assert submission.missing_fields.include?('demo')

    submission.demo = "something"
    refute submission.missing_fields.include?('demo')
  end
end
