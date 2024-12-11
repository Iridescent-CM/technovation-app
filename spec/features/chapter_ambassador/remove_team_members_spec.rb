require "rails_helper"

RSpec.feature "Remove an onboarding student" do
  let(:chapter) { FactoryBot.create(:chapter, :chicago, :onboarded) }
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter) }

  before do
    chapter_ambassador.chapterable_assignments.create(
      account: chapter_ambassador.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )
  end

  scenario "remove the student" do
    affiliated_student = FactoryBot.create(:student, :chicago, :not_assigned_to_chapter)
    affiliated_student.chapterable_assignments.create(
      account: affiliated_student.account,
      chapterable: chapter,
      season: Season.current.year
    )

    team = FactoryBot.create(:team)
    TeamRosterManaging.add(team, affiliated_student)

    onboarding_student = FactoryBot.create(:student, :chicago, :onboarding, :not_assigned_to_chapter)
    TeamRosterManaging.add(team, onboarding_student)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_chapter_admin_path)

    click_link "Teams"
    click_link "view"

    within(".onboarding_students") do
      click_link "remove this member"
    end

    expect(team.reload.students).not_to include(onboarding_student)
  end
end
