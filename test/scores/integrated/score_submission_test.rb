require "rails_helper"

class ScoreSubmissionTest < Capybara::Rails::TestCase
  def test_total_score
    category = ScoreCategory.create!(name: "Ideation")
    attribute = category.score_attributes.create!(label: "Was the idea good?")
    attribute.score_values.create!(label: "No", value: 0)
    attribute.score_values.create!(label: "Yes", value: 3)

    visit new_judges_score_path
    choose 'No'
    click_button 'Save'

    assert Feedback.last.total_score.zero?
  end
end
