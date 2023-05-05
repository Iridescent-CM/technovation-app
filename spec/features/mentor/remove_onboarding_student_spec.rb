require "rails_helper"

RSpec.feature "Metors removing students from a team" do
  scenario "Removing an onboarding student" do
    onboarding_student = FactoryBot.create(:onboarding_student, :onboarding)
    mentor = FactoryBot.create(:mentor, :onboarded)
    team = FactoryBot.create(:team)

    TeamRosterManaging.add(team, [onboarding_student, mentor])

    sign_in(mentor)
    within("#find-team") { click_link team.name }

    within(".onboarding_students") do
      click_link "remove this member"
    end

    expect(team.reload.mentors).to include(mentor)
    expect(team.students).not_to include(onboarding_student)
  end
end
