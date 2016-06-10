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

  end

  def test_score_submission
    visit new_judges_submission_score_path(submission)
    within('.ideation') { choose 'No' }
    within('.technology') { choose 'Yes' }
    click_button 'Save'

    assert_equal 1, submission.scores.count
    assert_equal 7, submission.scores.last.total
  end

  def test_edit_score
    visit new_judges_submission_score_path(submission)
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
    @submission ||= Submission.create!
  end
end
