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

    QuarterfinalScores.enable!
    visit scores_path

    expect(page).to have_link('', href: rubric_path(rubric))
  end
end
