require "rails_helper"

RSpec.feature "Club ambassadors registering", :js do
  let(:club) {
    FactoryBot.create(:club)
  }

  let(:club_ambassador_registration_invite) {
    UserInvitation.create!(
      profile_type: :club_ambassador,
      email: "club_ambassador_invite@example.com",
      club_id: club.id
    )
  }

  before do
    SeasonToggles.registration_open!
    visit signup_path(invite_code: club_ambassador_registration_invite.admin_permission_token)
  end

  scenario "Club ambassador registration steps and fields" do
    expect(page).to have_content("Club Ambassador")

    choose "Club Ambassador"
    click_button "Next"

    expect(page).to have_content("Club Ambassador Information")

    fill_in "First Name", with: "Hopeful Heart"
    fill_in "Last Name", with: "Bear"
    check "I confirm that I am 18 years or older"
    select "Prefer not to say", from: "Gender Identity"
    fill_in "Job Title", with: "Kindness spreader"
    click_button "Next"

    expect(page).to have_content("Data Use Terms")

    check "I AGREE TO THESE DATA USE TERMS"
    click_button "Next"

    expect(page).to have_content("Set your email and password")

    fill_in "Password", with: "secret12345"
    click_button "Submit this form"
  end
end
