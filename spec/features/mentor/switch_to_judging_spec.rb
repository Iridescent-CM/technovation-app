require "rails_helper"

RSpec.feature "Mentors switch to judging mode" do
  scenario "mentors with a judge profile can switch to judge mode" do
    mentor = FactoryBot.create(:mentor, :onboarded, :has_judge_profile)

    sign_in(mentor)

    expect(mentor.is_a_judge?).to be_truthy

    click_link "Switch to Judge mode"
    expect(current_path).to eq(judge_dashboard_path)

    click_link "Switch to Mentor mode"
    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "mentors without a judge profile see a judge mode link" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)

    expect(mentor.is_a_judge?).to be_falsey

    expect(page).to have_link("Switch to Judge mode")
  end

  scenario "mentors without a judge profile can create and switch to judge profile" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)

    expect(mentor.is_a_judge?).to be_falsey

    click_link "Switch to Judge mode"
    expect(current_path).to eq(judge_dashboard_path)

    expect(mentor.account_id).to eq(JudgeProfile.last.account_id)

    click_link "Switch to Mentor mode"
    expect(current_path).to eq(mentor_dashboard_path)
  end
end
