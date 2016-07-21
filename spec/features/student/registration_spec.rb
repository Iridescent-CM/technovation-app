require "rails_helper"

RSpec.feature "Register as a student" do
  before do
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
  end

  scenario "Redirected to student dashboard" do
    expect(current_path).to eq(student_dashboard_path)
  end

  scenario "parent is emailed the consent form link" do
    expect(ActionMailer::Base.deliveries.count).not_to be_zero, "no email sent"

    mail = ActionMailer::Base.deliveries.last

    expect(mail.to).to eq(["parents@example.com"])
    expect(mail.body.parts.last.to_s).to include("href=\"#{new_parental_consent_url(token: StudentAccount.last.consent_token)}\"")
  end
end
