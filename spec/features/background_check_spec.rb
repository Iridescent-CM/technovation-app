require "rails_helper"

RSpec.feature "background checks" do
  %i{mentor regional_ambassador}.each do |account|
    scenario "Complete a #{account} background check", :vcr do
      a = FactoryGirl.create(account, background_check: nil)
      sign_in(a)
      click_link "Submit Background Check"

      fill_in "Zipcode", with: 60622
      fill_in "Ssn", with: "111-11-2001"
      fill_in "Driver license state", with: "CA"
      click_button "Submit"

      expect(a.reload.background_check).to be_present
    end
  end
end
