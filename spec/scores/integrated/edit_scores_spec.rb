require "rails_helper"

RSpec.feature "Edit scores" do
  scenario "A judge edits a score" do
    Season.open!
    Submissions.open!
    Semifinal.open!

    region = create(:region)
    event = create(:event, :non_virtual_event, region: region)
    user = create(:user, :judge, event: event, judging_region: region)
    team = create(:team, :eligible, region: region, event: event)
    rubric = create(:rubric, team: team, user: user, stage: Rubric.stages[:quarterfinal])

    sign_in(user)
    visit edit_rubric_path(rubric)

    choose '1', from: :address_problem
    click_button 'Save'

    expect(rubric.reload.address_problem).to eq(1)
  end
end
