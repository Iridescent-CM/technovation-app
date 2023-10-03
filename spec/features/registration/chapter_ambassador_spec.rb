require "rails_helper"

RSpec.feature "Chapter ambassadors registering", :js do
  let(:chapter_ambassado_registration_invite) {
    UserInvitation.create!(
      profile_type: :chapter_ambassador,
      email: "chapter_ambassador_invite@example.com"
    )
  }

  before do
    SeasonToggles.registration_open!

    visit signup_path(invite_code: chapter_ambassado_registration_invite.admin_permission_token)
  end

  scenario "Chapter ambassador registration steps and fields" do
    expect(page).to have_content("Chapter Ambassador")

    choose "Chapter Ambassador"
    click_button "Next"

    expect(page).to have_content("Chapter Ambassador Information")

    fill_in "First Name", with: "Hopeful Heart"
    fill_in "Last Name", with: "Bear"
    select "Prefer not to say", from: "Gender Identity"
    fill_in "Birthday", with: 32.years.ago
    fill_in "Company Name", with: "Care-a-Lot Inc."
    fill_in "Job Title", with: "Kindness spreader"
    fill_in "chapterAmbassadorBio", with: "I am always brimming with hope, happiness, and positivity. I am the kind of bear that will tell you everything's going to be all right in the end. I see the silver lining around every dark cloud, and know that no matter how dire a situation may seem, there's always chance to make things better."
    click_button "Next"

    expect(page).to have_content("Data Use Terms")

    check "I AGREE TO THESE DATA USE TERMS"
    click_button "Next"

    expect(page).to have_content("Set your email and password")

    fill_in "Email Address", with: "hopeful.heart@test.com"
    fill_in "Password", with: "secret12345"
    click_button "Submit this form"
  end
end
