require "rails_helper"

RSpec.describe "Saving a location in a geopolitically sensitive area", :js do
  before do
    sign_in(:student)

    click_button "Profile"
    click_button "Region"

    fill_in "Country", with: "Israel"
    fill_in "State", with: "Tel Aviv"
    fill_in "City", with: "Tel Aviv"

    click_button "Next"
  end

  it "prompts the user with a choice when Israel is the country" do
    within(".suggestions") do
      expect(page).to have_css(".suggestion", count: 2)
      expect(page).to have_content("Israel")
      expect(page).to have_content("Palestine")
    end
  end

  it "saves the changes in the database" do
    within(".suggestions") do
      find(".suggestion", text: "Israel").click
    end

    click_button "Confirm"
    expect(current_path).to eq(student_dashboard_path)
    visit student_profile_path
    click_button "Location"
    expect(page).to have_content("Tel Aviv, Tel Aviv, Israel")
  end
end