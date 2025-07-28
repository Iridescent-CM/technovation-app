require "rails_helper"

RSpec.feature "Mentors removing students from a team" do
  scenario "Removing an onboarding student" do
    onboarding_student = FactoryBot.create(:onboarding_student, :onboarding)
    mentor = FactoryBot.create(:mentor, :onboarded)
    team = FactoryBot.create(:team)

    TeamRosterManaging.add(team, [onboarding_student, mentor])

    sign_in(mentor)
    visit mentor_team_students_path(team)

    click_link "remove this member"

    expect(team.reload.mentors).to include(mentor)
    expect(team.students).not_to include(onboarding_student)
  end
end
