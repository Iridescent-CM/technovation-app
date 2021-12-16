require "rails_helper"

RSpec.xfeature "Remove an onboarding student" do
  scenario "remove the student" do
    student = FactoryBot.create(:student, :onboarding)
    mentor = FactoryBot.create(:mentor, :onboarded)
    team = FactoryBot.create(:team)

    TeamRosterManaging.add(team, [student, mentor])

    sign_in(mentor)
    within("#find-team") { click_link team.name }

    within(".onboarding_students") do
      click_link "remove this member"
    end

    expect(team.reload.mentors).to include(mentor)
    expect(team.students).not_to include(student)
  end
end
