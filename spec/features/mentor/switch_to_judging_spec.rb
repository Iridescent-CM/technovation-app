require "rails_helper"

RSpec.feature "Mentors switch to judging mode" do
  scenario "mentors can switch to judge mode" do
    mentor = FactoryBot.create(:mentor)
    sign_in(mentor)

    click_link "Switch to Judge mode"
    expect(current_path).to eq(judge_dashboard_path)
  end
end
