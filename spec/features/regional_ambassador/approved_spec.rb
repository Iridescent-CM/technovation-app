require "rails_helper"

RSpec.feature "Approved regional ambassadors" do
  scenario "once approved, they have the access they need" do
    approved_ambassador = FactoryGirl.create(:regional_ambassador, :approved)
    sign_in(approved_ambassador)
    expect(current_path).to eq(regional_ambassador_dashboard_path)
    expect(page).to have_content("Recent activity")
    expect(page).to have_content("#{Season.current.year} Illinois Snapshot")
  end
end
