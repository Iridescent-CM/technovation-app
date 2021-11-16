require "rails_helper"

RSpec.feature "Remove an onboarding student" do
  scenario "remove the student" do
    onb_student = FactoryBot.create(:student, :onboarding)

    student = FactoryBot.create(:student, :onboarded)
    team = FactoryBot.create(:team)

    TeamRosterManaging.add(team, [onb_student, student])

    sign_in(student)
    click_link "My Team"

    within(".onboarding_students") do
      click_link "remove this member"
    end

    expect(team.reload.students).not_to include(onb_student)
    expect(team.students).to include(student)
  end
end