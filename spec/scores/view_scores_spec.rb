require "rails_helper"

RSpec.feature "View scores" do
  scenario "scores not available" do
    Season.open!
    Submissions.open!

    user = create(:user)
    team = create(:team, name: 'Cool team')
    team.team_requests.create!(user: user, approved: true)
    create(:rubric, team: team, stage: Rubric.stages[:quarterfinal])

    sign_in(user)

    visit scores_path

    expect(page).to have_content('There are no scores available for Cool team.')
  end

  scenario "scores available" do
    Season.open!
    Submissions.open!
    QuarterfinalScores.enable!

    user = create(:user)
    team = create(:team, name: 'Cool team')
    team.team_requests.create!(user: user, approved: true)
    create(:rubric, team: team, stage: Rubric.stages[:quarterfinal])

    sign_in(user)

    visit scores_path

    expect(page).to have_link('Judge feedback 1')
  end
end
