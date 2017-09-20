require "rails_helper"

RSpec.feature "Admin / RA logging in as a user" do
  scenario "RA logging in as a student" do
    student = FactoryGirl.create(:student, :geocoded, :on_team)
    ra = FactoryGirl.create(:ambassador)

    sign_in(ra)

    visit regional_ambassador_participant_path(student.account)

    click_link "Login as #{student.full_name}"
    expect(current_path).to eq(student_dashboard_path)

    click_link "My team"
    expect(current_path).to eq(student_team_path(student.team))

    click_link "return to RA mode"
    expect(current_path).to eq(regional_ambassador_participant_path(student.account))
  end

  scenario "RA logging in as a mentor" do
    mentor = FactoryGirl.create(:mentor, :geocoded, :on_team)
    ra = FactoryGirl.create(:ambassador)

    sign_in(ra)

    visit regional_ambassador_participant_path(mentor.account)

    click_link "Login as #{mentor.full_name}"
    expect(current_path).to eq(mentor_dashboard_path)

    click_link "My teams"
    click_link mentor.teams.first.name
    expect(current_path).to eq(mentor_team_path(mentor.teams.first))

    click_link "return to RA mode"
    expect(current_path).to eq(regional_ambassador_participant_path(mentor.account))
  end

  scenario "RA logging in as a judge" do
    judge = FactoryGirl.create(:judge, :geocoded)
    ra = FactoryGirl.create(:ambassador)

    sign_in(ra)

    visit regional_ambassador_participant_path(judge.account)

    click_link "Login as #{judge.full_name}"
    expect(current_path).to eq(judge_dashboard_path)

    click_link "My profile"
    expect(current_path).to eq(judge_profile_path)

    click_link "return to RA mode"
    expect(current_path).to eq(regional_ambassador_participant_path(judge.account))
  end

  scenario "Admin logging in as a user"
end
