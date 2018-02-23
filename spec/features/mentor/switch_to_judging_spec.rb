require "rails_helper"

RSpec.feature "Mentors switch to judging mode" do
  scenario "when judge signups are not enabled" do
    skip "Not hiding judge mode link behind season toggle"

    SeasonToggles.disable_signup(:judge)

    mentor = FactoryBot.create(:mentor)
    sign_in(mentor)

    expect(page).not_to have_link("Switch to Judge mode")
  end

  scenario "when judge signups are enabled" do
    SeasonToggles.enable_signup(:judge)

    mentor = FactoryBot.create(:mentor)
    sign_in(mentor)

    click_link "Switch to Judge mode"
    expect(current_path).to eq(judge_dashboard_path)
  end
end
