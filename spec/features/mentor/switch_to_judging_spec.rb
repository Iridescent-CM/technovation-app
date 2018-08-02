require "rails_helper"

RSpec.feature "Mentors switch to judging mode" do
  scenario "mentors with a judge profile can switch to judge mode" do
    mentor = FactoryBot.create(:mentor, :has_judge_profile)

    sign_in(mentor)

    expect(mentor.is_a_judge?).to be_truthy

    click_link "Switch to Judge mode"
    expect(current_path).to eq(judge_dashboard_path)

    click_link "Switch to Mentor mode"
    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "mentors with a judge profile can browse to judge profile" do
    mentor = FactoryBot.create(:mentor, :has_judge_profile)

    sign_in(mentor)

    visit judge_dashboard_path

    expect(current_path).to eq(judge_dashboard_path)
    expect(page).to have_link("Switch to Mentor mode")
  end

  scenario "mentors without a judge profile do not see a judge mode link" do
    mentor = FactoryBot.create(:mentor)

    sign_in(mentor)

    expect(mentor.is_a_judge?).to be_falsey

    expect(page).not_to have_link("Switch to Judge mode")
  end

  scenario "mentors without a judge profile cannot browse to judge profile" do
    mentor = FactoryBot.create(:mentor)

    sign_in(mentor)

    visit judge_dashboard_path

    expect(current_path).to eq(mentor_dashboard_path)
    expect(page).to have_content("You don't have permission to go there!")
  end
end
