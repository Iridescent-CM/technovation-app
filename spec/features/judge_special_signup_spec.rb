require "rails_helper"

RSpec.feature "Judges sign up at special link" do
  scenario "visit the normal url" do
    visit judge_signup_path
    expect(current_path).to eq(root_path)
  end

  scenario "visit with the special token" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)

    expect(current_path).to eq(judge_signup_path)

    expect(page).to have_css("#new_judge_profile input[type=email]")
    expect(page).to have_css("#new_judge_profile input[type=password]")
  end

  scenario "sign up" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)

    expect(current_path).to eq(judge_signup_path)

    click_button "Create Your Account"

    fill_in "Email", with: "my@email.com"
    fill_in "First name", with: "Judgey"
    fill_in "Last name", with: "McJudgeface"
    select_date 20.years.ago, from: "Date of birth"
    fill_in "Company name", with: "testing"
    fill_in "Job title", with: "test"
    fill_in "Create a password", with: "secret1234"

    click_button "Create Your Account"

    expect(current_path).to eq(judge_dashboard_path)
  end

  scenario "encounter validation errors with the special token" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)

    expect(current_path).to eq(judge_signup_path)

    click_button "Create Your Account"

    expect(page).to have_css(
      "#new_judge_profile .field_with_errors input[type=email]"
    )

    expect(page).to have_css(
      "#new_judge_profile .field_with_errors input[type=password]"
    )
  end
end
