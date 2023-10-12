require "rails_helper"

RSpec.feature "Parents registering", :js do
  before do
    SeasonToggles.registration_open!

    visit "/signup"
  end

  scenario "Parent registration steps and fields" do
    choose "I am registering my 8-12 year old* daughter"
    click_button "Next"

    expect(page).to have_content("Student Information")

    fill_in "First Name", with: "Lotsa Heart"
    fill_in "Last Name", with: "Elephant"
    fill_in "Birthday", with: 9.years.ago
    fill_in "School Name", with: "Care-a-Lot Elementary School"
    within "#parent-information" do
      fill_in "Name", with: "Wish Bear"
      fill_in "Parent Email Address", with: "wish.bear@test.com"
    end
    click_button "Next"

    expect(page).to have_content("Data Use Terms")

    check "I AGREE TO THESE DATA USE TERMS"
    click_button "Next"

    expect(page).to have_content("Set your email and password")

    fill_in "Password", with: "secret12345"
    click_button "Submit this form"
  end
end
