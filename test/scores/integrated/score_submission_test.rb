require "rails_helper"

class ScoreSubmissionTest < Capybara::Rails::TestCase
  def test_total_score
    category = ScoreCategory.create!(name: "Ideation")
    attribute = category.score_attributes.create!(label: "Was the idea good?")
    attribute.score_values.create!(label: "No", value: 0)
    attribute.score_values.create!(label: "Yes", value: 3)

    category = ScoreCategory.create!(name: "Technology")
    attribute = category.score_attributes.create!(label: "Was the tech good?")
    attribute.score_values.create!(label: "No", value: 0)
    attribute.score_values.create!(label: "Yes", value: 3)

    visit new_judges_score_path
    within('.ideation') { choose 'Yes' }
    within('.technology') { choose 'Yes' }
    click_button 'Save'

    assert_equal 1, Score.count
    assert_equal 6, Score.last.total
  end
end
