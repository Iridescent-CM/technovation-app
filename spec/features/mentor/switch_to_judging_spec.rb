require "rails_helper"

RSpec.feature "Mentors switch to judging mode" do
  scenario "when judge signups are not enabled" do
    SeasonToggles.disable_signup(:judge)

    mentor = FactoryBot.create(:mentor)
    sign_in(mentor)

    expect(page).not_to have_link("Switch to Judging")
  end

  scenario "when judge signups are enabled" do
    SeasonToggles.enable_signup(:judge)

    mentor = FactoryBot.create(:mentor)
    sign_in(mentor)

    click_link "Switch to Judging"
    expect(current_path).to eq(judge_dashboard_path)
  end
end
