require "rails_helper"

RSpec.feature "Remove an onboarding student" do
  scenario "remove the student" do
    student = FactoryBot.create(:student, :onboarding)
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)
    team = FactoryBot.create(:team)

    TeamRosterManaging.add(team, student)

    sign_in(chapter_ambassador)
    click_link "Teams"
    click_link "view"

    within(".onboarding_students") do
      click_link "remove this member"
    end

    expect(team.reload.students).not_to include(student)
  end
end
