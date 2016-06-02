require "rails_helper"

RSpec.feature "View scores" do
  let(:user) { create(:user) }
  let(:team) { create(:team, name: 'Cool team') }

  before do
    Season.open!
    Submissions.open!

    team.team_requests.create!(user: user, approved: true)

    sign_in(user)
  end

  scenario "scores not available" do
    rubric = create(:rubric, team: team, stage: Rubric.stages[:quarterfinal])
    visit scores_path
    expect(page).not_to have_link('', href: rubric_path(rubric))
  end

  scenario "scores available" do
    rubric = create(:rubric, team: team, stage: Rubric.stages[:quarterfinal])

    Quarterfinal.enable_scores!
    visit scores_path

    expect(page).to have_link('', href: rubric_path(rubric))
  end

  scenario "view scores" do
    rubric = create(:rubric, team: team,
                             description_comment: "You did great on the description",
                             stage: Rubric.stages[:quarterfinal])

    Quarterfinal.enable_scores!
    visit scores_path
    click_link '', href: rubric_path(rubric)

    expect(page).to have_content("You did great on the description")
  end

  scenario 'meaningful scores' do
    zero_feedback = create(:rubric, team: team, stage: Rubric.stages[:quarterfinal])

    lowest_feedback = create(:rubric, team: team, stage: Rubric.stages[:quarterfinal],
                             description_comment: "1 point feedback")

    create(:rubric, team: team, stage: Rubric.stages[:quarterfinal],
           address_problem_comment: "2 point feedback")

    create(:rubric, team: team, stage: Rubric.stages[:quarterfinal],
           functional_comment: "3 point feedback")

    create(:rubric, team: team, stage: Rubric.stages[:quarterfinal],
           address_problem_comment: "2 point feedback",
           external_resources_comment: "3 point feedback")

    highest_feedback = create(:rubric, team: team, stage: Rubric.stages[:quarterfinal],
                              description_comment: "1 point feedback",
                              address_problem_comment: "2 point feedback",
                              external_resources_comment: "3 point feedback")

    Quarterfinal.enable_scores!
    visit scores_path

    expect(page).not_to have_link('', href: rubric_path(zero_feedback))
    expect(page.find('.scores li:first-child')).to have_link('', href: rubric_path(highest_feedback))
    expect(page.find('.scores li:last-child')).to have_link('', href: rubric_path(lowest_feedback))

    click_link('', href: rubric_path(lowest_feedback))

    expect(page).to have_css ".explanation", text: "No"
  end
end
