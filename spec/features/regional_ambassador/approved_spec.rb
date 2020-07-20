require "rails_helper"

RSpec.feature "Approved chapter ambassadors" do
  scenario "updating their dashboard blurb" do
    ambassador = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(ambassador)

    expect(current_path).to eq(regional_ambassador_dashboard_path)

    expect(page).to have_content("Promote your program to your region")

    fill_in "Short summary", with: "Something that is 280 characters or less"

    select "Twitter",
      from: "regional_ambassador_profile_regional_links_attributes_0_name"

    fill_in "regional_ambassador_profile_regional_links_attributes_0_value",
      with: "technomx"

    click_button "Save"

    expect(current_path).to eq(regional_ambassador_dashboard_path)

    within("#ra-info") do
      expect(page).to have_link(
        "@technomx",
        href: "https://www.twitter.com/technomx"
      )
      expect(page).to have_content("Something that is 280 characters or less")
    end
  end
end
