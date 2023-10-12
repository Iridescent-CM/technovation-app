require "rails_helper"

RSpec.feature "Mentors registering", :js do
  before do
    SeasonToggles.registration_open!

    visit "/signup"
  end

  scenario "Mentor registration steps and fields" do
    choose "I am over 18 years old and will guide a team"
    click_button "Next"

    expect(page).to have_content("Mentor Information")

    fill_in "First Name", with: "Cheer"
    fill_in "Last Name", with: "Bear"
    select "Prefer not to say", from: "Gender Identity"
    fill_in "Birthday", with: 39.years.ago
    fill_in "Company Name", with: "Care-a-Lot Castle"
    fill_in "Job Title", with: "Spellcaster"
    check "Industry professional"
    fill_in "mentorBio", with: "I'm a very happy and perky bear who lives up to my name, I made it my goal to help everyone to be joyous as me. Known to break into cheers and chants at the drop of a hat. I'm exuberant, bouncy, and just a plain happy ball of pink fluff!"
    click_button "Next"

    expect(page).to have_content("Data Use Terms")

    check "I AGREE TO THESE DATA USE TERMS"
    click_button "Next"

    expect(page).to have_content("Set your email and password")

    fill_in "Email Address", with: "cheer@test.com"
    fill_in "Password", with: "secret12345"
    click_button "Submit this form"
  end
end
