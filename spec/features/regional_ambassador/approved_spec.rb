require "rails_helper"

RSpec.feature "Approved regional ambassadors" do
  scenario "updating their dashboard blurb" do
    ambassador = FactoryGirl.create(:regional_ambassador, :approved)

    sign_in(ambassador)

    expect(current_path).to eq(regional_ambassador_dashboard_path)

    expect(page).to have_content("Your introduction")

    expect(page).to have_content(
      "Participants in your region can see this on their dashboards"
    )

    click_link "Edit your introduction"

    fill_in "Short summary", with: "Something that is 280 characters or less"
    select "twitter", from: "regional_ambassador_profile_links[][type]"
    fill_in "regional_ambassador_profile_links_0_value", with: "technomx"

    click_button "Save"

    expect(current_path).to eq(regional_ambassador_dashboard_path)

    within(".ra-info--dashboard-intro") do
      expect(page).to have_link("@technomx", href: "https://twitter.com/technomx")
      expect(page).to have_content("Something that is 280 characters or less")
    end
  end
end
