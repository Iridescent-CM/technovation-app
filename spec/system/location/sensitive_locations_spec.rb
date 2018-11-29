require "rails_helper"

RSpec.describe "Saving a location in a geopolitically sensitive area", :js do
  before do
    sign_in(:student)

    click_button "Profile"
    click_button "Region"

    click_link "reset this form"
    fill_in_vue_select "Country / Territory", with: "Israel"
    fill_in_vue_select "State / Province", with: "Tel-Aviv"
    fill_in "City", with: "Tel Aviv"

    click_button "Next"
  end

  it "saves the changes in the database" do
    visit student_profile_path
    click_button "Location"
    expect(page).to have_content("Tel Aviv, Tel-Aviv, Israel")
  end
end