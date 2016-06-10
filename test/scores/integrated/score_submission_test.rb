require "rails_helper"

class ScoreSubmissionTest < Capybara::Rails::TestCase
  def setup
    CreateScoringRubric.(category: "Ideation",
                         attributes: [{ label: "Was the idea good?",
                                        values: [{ label: "No", value: 0 },
                                                 { label: "Yes", value: 3 }] }])
    CreateScoringRubric.(category: "Technology",
                         attributes: [{ label: "Was the tech good?",
                                        values: [{ label: "No", value: 0 },
                                                 { label: "Yes", value: 7 }] }])

    submission
  end

  def test_score_submission
    visit judges_scores_path
    click_link 'Judge submission for Test team'
    within('.ideation') { choose 'No' }
    within('.technology') { choose 'Yes' }
    click_button 'Save'

    assert_equal 1, submission.scores.count
    assert_equal 7, submission.scores.last.total
  end

  def test_edit_score
    visit judges_scores_path
    click_link 'Judge submission for Test team'
    within('.ideation') { choose 'No' }
    within('.technology') { choose 'Yes' }
    click_button 'Save'

    click_link 'Edit'
    within('.ideation') { choose 'Yes' }
    within('.technology') { choose 'No' }
    click_button 'Save'

    assert_equal 1, submission.scores.count
    assert_equal 3, submission.scores.last.total
  end

  private
  def submission
    return @submission if defined?(@submission)
    team = Team.create!(name: "Test team",
                        description: "Real creative name",
                        division: Division.high_school,
                        region: Region.find_or_create_by(name: "US/Canada"))
    @submission = team.submissions.create!
  end
end
