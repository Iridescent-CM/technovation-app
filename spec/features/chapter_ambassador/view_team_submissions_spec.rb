require "rails_helper"

RSpec.feature "Chapter Ambassador viewing their team submissions" do
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

  scenario "displays team submissions of students assigned to their chapter" do
    affiliated_student = FactoryBot.create(:student, :chicago, :not_assigned_to_chapter)

    affiliated_student.chapterable_assignments.create(
      account: affiliated_student.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )

    team = FactoryBot.create(:team)
    TeamRosterManaging.add(team, affiliated_student)

    submission = FactoryBot.create(:team_submission,
      app_name: "hello",
      team: team)

    affiliated_student_2 = FactoryBot.create(:student, :chicago, :not_assigned_to_chapter)

    affiliated_student_2.chapterable_assignments.create(
      account: affiliated_student_2.account,
      chapterable: chapter,
      season: Season.current.year,
      primary: true
    )

    team_2 = FactoryBot.create(:team)
    TeamRosterManaging.add(team_2, affiliated_student_2)

    submission_2 = FactoryBot.create(:team_submission,
      app_name: "hello 2",
      team: team_2)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_team_submissions_path)

    expect(page).to have_content(submission.app_name)
    expect(page).to have_content(submission_2.app_name)
  end

  scenario "does not display team submissions of students not assigned to their chapter" do
    affiliated_student = FactoryBot.create(:student, :brazil)
    team = FactoryBot.create(:team)
    TeamRosterManaging.add(team, affiliated_student)

    submission = FactoryBot.create(:team_submission,
      app_name: "hello brazil",
      team: team)

    sign_in(chapter_ambassador)
    visit(chapter_ambassador_teams_path)

    expect(page).not_to have_content(submission.app_name)
  end
end
