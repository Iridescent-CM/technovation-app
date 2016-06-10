require "rails_helper"

class ScoreSubmissionTest < Capybara::Rails::TestCase
  def test_total_score
    CreateScoringRubric.(category: "Ideation",
                         attributes: [{ label: "Was the idea good?",
                                        values: [{ label: "No", value: 0 },
                                                 { label: "Yes", value: 3 }] }])
    CreateScoringRubric.(category: "Technology",
                         attributes: [{ label: "Was the tech good?",
                                        values: [{ label: "No", value: 0 },
                                                 { label: "Yes", value: 7 }] }])

    visit new_judges_score_path
    within('.ideation') { choose 'No' }
    within('.technology') { choose 'Yes' }
    click_button 'Save'

    assert_equal 1, Score.count
    assert_equal 7, Score.last.total
  end
end
