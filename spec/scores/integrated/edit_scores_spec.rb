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

    expect(page).to have_css 'label', text: "No [0]"

    fill_in 'rubric_description_comment', with: 'Great description, well done!'
    click_button 'Submit'

    expect(rubric.reload.description_comment).to eq('Great description, well done!')
  end
end
