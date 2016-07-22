require "rails_helper"

RSpec.feature "Student signs up after being invited to a team" do
  scenario "with the invite token in the cookies" do
    invite = FactoryGirl.create(:team_member_invite, invitee: nil)

    visit team_member_invite_path(invite)
    click_button "Accept invitation to #{invite.team_name}"

    fill_in "First name", with: "Student"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 15.years, from: "Date of birth"

    select "United States", from: "Country"
    fill_in "State / Province", with: "IL"
    fill_in "City", with: "Chicago"

    fill_in "School name", with: "John Hughes High"
    select "Yes", from: "Are you in Secondary (High) School?"

    fill_in "Parent or guardian's name", with: "Parenty Parent"
    fill_in "Parent or guardian's email", with: "parents@example.com"

    fill_in "Email", with: "student@student.com"
    fill_in "Password", with: "secret1234"
    fill_in "Confirm password", with: "secret1234"

    click_button "Sign up"

    click_link "My team"

    expect(current_path).to eq(student_team_path(invite.team))
    expect(page).to have_content(invite.team_name)
  end

  scenario "when the student's email is in an invite" do
    invite = FactoryGirl.create(:team_member_invite,
                                invitee_email: "student@student.com")

    visit student_signup_path

    fill_in "First name", with: "Student"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 15.years, from: "Date of birth"

    select "United States", from: "Country"
    fill_in "State / Province", with: "IL"
    fill_in "City", with: "Chicago"

    fill_in "School name", with: "John Hughes High"
    select "Yes", from: "Are you in Secondary (High) School?"

    fill_in "Parent or guardian's name", with: "Parenty Parent"
    fill_in "Parent or guardian's email", with: "parents@example.com"

    fill_in "Email", with: "student@student.com"
    fill_in "Password", with: "secret1234"
    fill_in "Confirm password", with: "secret1234"

    click_button "Sign up"

    click_link "My team"

    expect(current_path).to eq(student_team_path(invite.team))
    expect(page).to have_content(invite.team_name)
  end
end
