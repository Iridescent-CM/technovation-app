require "rails_helper"

class ScoreExpertiseTest < Capybara::Rails::TestCase
  def test_judge_sees_their_own_expertise
    create_test_scoring_environment

    ScoreCategory.find_or_create_by(name: "Ideation")
    tech = ScoreCategory.find_or_create_by(name: "Technology")
    biz = ScoreCategory.find_or_create_by(name: "Business")

    judge = CreateAuthentication.(judge_attributes({
      judge_profile_attributes: { expertise_ids: [tech.id, biz.id] }
    }))

    sign_in(judge)

    visit judge_scores_path
    click_link 'Judge submissions'

    assert page.has_content?('Technology')
    assert page.has_content?('Business')
    refute page.has_content?('Ideation')
  end
end
