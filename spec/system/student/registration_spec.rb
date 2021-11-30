require "rails_helper"

RSpec.describe "Register as a student", :js do
  it "using the sign up form" do
    # Sign up using the sign up form
    set_signup_token("student@student.com")

    visit student_signup_path

    fill_in "First name", with: "Student"
    fill_in "Last name", with: "McGee"

    select_chosen_date Date.today - 15.years, from: "Date of birth"

    fill_in "School name", with: "John Hughes High."

    click_button "Create Your Account"

    # Data agreement missing - redirect to data use terms agreement page
    expect(current_path).to eq(edit_terms_agreement_path)

    expect(page).to have_selector('#terms_agreement_checkbox', visible: true)

    check "terms_agreement_checkbox"

    click_button "Submit"

    # Redirect to student dashboard
    expect(page).to have_current_path(student_dashboard_path, ignore_query: true)

    # Confirm signup attempt attached
    attempt = SignupAttempt.find_by(
      account_id: StudentProfile.last.account_id
    )
    expect(attempt).to be_present

    # Assert email is confirmed on signup
    visit student_dashboard_path
    expect(page).not_to have_content("You changed your email address")
  end
end

RSpec.describe "Register from team invite", :js do
  let(:email) { "Student@test.com" }
  let(:team) { FactoryBot.create(:team) }
  let(:inviter) { team.students.first }

  before do
    SeasonToggles.enable_signup(:student)

    team.team_member_invites.create!(
      inviter: inviter,
      invitee_email: email,
    )
  end

  scenario "No user logged in" do
    visit student_signup_path(
      token: SignupAttempt.find_by(email: email.strip.downcase).activation_token
    )
    expect_profile_creation_page(email)
  end

  scenario "Other user logged in" do
    sign_in(inviter)
    visit student_signup_path(
      token: SignupAttempt.find_by(email: email.strip.downcase).activation_token
    )
    expect_profile_creation_page(email)
  end

  def expect_profile_creation_page(email)
    within(".new_student_profile") {
      expect(page).to have_content("Your email address: #{email.strip.downcase}")
    }
    within(".navigation") {
      expect(page).to have_link("Sign in")
    }
  end
end
