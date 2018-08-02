require "rails_helper"

RSpec.feature "Mentors switch to judging mode" do
  scenario "mentors with a judge profile can switch to judge mode" do
    mentor = FactoryBot.create(:mentor, :has_judge_profile)

    sign_in(mentor)

    expect(mentor.is_a_judge?).to be_truthy

    click_link "Switch to Judge mode"
    expect(current_path).to eq(judge_dashboard_path)
  end

  scenario "mentors without a judge profile do not see a judge mode link" do
    mentor = FactoryBot.create(:mentor)

    sign_in(mentor)

    expect(mentor.is_a_judge?).to be_falsey

    expect(page).not_to have_link("Switch to Judge mode")
  end
end
