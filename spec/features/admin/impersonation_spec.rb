require "rails_helper"

RSpec.feature "Admins impersonating other accounts" do
  before do
    admin = FactoryBot.create(:admin)
    sign_in(admin)
  end

  scenario "An admin impersonating a student" do
    student = FactoryBot.create(:student, :geocoded, :on_team)

    visit admin_participant_path(student.account)

    click_link "Login as #{student.full_name}"
    expect(current_path).to eq(student_dashboard_path)

    click_link "My Team"
    expect(current_path).to eq(student_team_path(student.team))

    click_link "return to Admin mode"
    expect(current_path).to eq(admin_participant_path(student.account))
  end

  scenario "An admin impersonating a mentor" do
    mentor = FactoryBot.create(:mentor, :onboarded, :geocoded, :on_team)

    visit admin_participant_path(mentor.account)

    click_link "Login as #{mentor.full_name}"
    expect(current_path).to eq(mentor_dashboard_path)

    within("#find-team") { click_link mentor.teams.first.name }
    expect(current_path).to eq(mentor_team_path(mentor.teams.first))

    click_link "return to Admin mode"
    expect(current_path).to eq(admin_participant_path(mentor.account))
  end

  scenario "An admin impersonating a judge" do
    judge = FactoryBot.create(:judge, :geocoded)

    visit admin_participant_path(judge.account)

    click_link "Login as #{judge.full_name}"
    expect(current_path).to eq(judge_dashboard_path)

    click_link "My Profile"
    expect(current_path).to eq(judge_profile_path)

    click_link "return to Admin mode"
    expect(current_path).to eq(admin_participant_path(judge.account))
  end

  scenario "An admin impersonating a chapter ambassador" do
    chapter_ambassador = FactoryBot.create(:ambassador)

    visit admin_participant_path(chapter_ambassador.account)

    click_link "Login as #{chapter_ambassador.full_name}"
    expect(current_path).to eq(chapter_ambassador_dashboard_path)

    visit(chapter_ambassador_chapter_admin_path)
    click_link "My Account"
    expect(current_path).to eq(chapter_ambassador_profile_path)

    click_link "return to Admin mode"
    expect(current_path).to eq(admin_participant_path(chapter_ambassador.account))
  end
end
