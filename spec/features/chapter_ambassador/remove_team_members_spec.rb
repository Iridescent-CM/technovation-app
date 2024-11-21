require "rails_helper"

RSpec.feature "Remove an onboarding student" do
  let(:chapter) { FactoryBot.create(:chapter, :chicago, :onboarded) }
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter) }

  before do
    chapter_ambassador.chapter_assignments.create(
      account: chapter_ambassador.account,
      chapter: chapter,
      season: Season.current.year
    )
  end

  scenario "remove the student" do
    affiliated_onboarding_student = FactoryBot.create(:student, :chicago, :onboarding)
    affiliated_onboarding_student.chapter_assignments.create(
      account: affiliated_onboarding_student.account,
      chapter: chapter,
      season: Season.current.year
    )

    team = FactoryBot.create(:team)
    TeamRosterManaging.add(team, affiliated_onboarding_student)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Teams"
    click_link "view"

    within(".onboarding_students") do
      click_link "remove this member"
    end

    expect(team.reload.students).not_to include(affiliated_onboarding_student)
  end
end
