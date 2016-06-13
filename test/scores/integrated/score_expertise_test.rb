require "rails_helper"

class ScoreExpertiseTest < Capybara::Rails::TestCase
  def test_judge_sees_their_own_expertise
    create_test_scoring_environment

    CreateExpertise.(name: "Ideation")
    tech = CreateExpertise.(name: "Technology")
    biz = CreateExpertise.(name: "Business")

    judge = CreateJudge.(email: "judge@judging.com",
                         password: "judge@judging.com",
                         password_confirmation: "judge@judging.com",
                         expertises: [tech, biz])

    sign_in(judge)

    visit judges_scores_path
    click_link 'Judge submission for Test team'

    refute page.has_content?('Ideation')
  end
end
