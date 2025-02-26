require "rails_helper"

RSpec.feature "Chapter Ambassador viewing their teams" do
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

  scenario "displays teams of students assigned to their chapter" do
    affiliated_student = FactoryBot.create(:student, :chicago, :not_assigned_to_chapter)
    affiliated_student.chapterable_assignments.create(
      account: affiliated_student.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )

    team = FactoryBot.create(:team)
    TeamRosterManaging.add(team, affiliated_student)

    affiliated_student_2 = FactoryBot.create(:student, :chicago, :not_assigned_to_chapter)
    affiliated_student_2.chapterable_assignments.create(
      account: affiliated_student_2.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )

    team_2 = FactoryBot.create(:team)
    TeamRosterManaging.add(team_2, affiliated_student_2)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_teams_path)

    expect(page).to have_content(affiliated_student.team.name)
    expect(page).to have_content(affiliated_student_2.team.name)
  end

  scenario "does not display teams of students not assigned to their chapter" do
    affiliated_student = FactoryBot.create(:student, :brazil)
    team = FactoryBot.create(:team)
    TeamRosterManaging.add(team, affiliated_student)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_teams_path)

    expect(page).not_to have_content(affiliated_student.team.name)
  end
end
