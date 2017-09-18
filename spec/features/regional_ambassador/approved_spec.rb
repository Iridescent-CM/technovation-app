require "rails_helper"

RSpec.feature "Approved regional ambassadors" do
  scenario "once approved, they have the access they need" do
    skip "this is being reset"
    approved_ambassador = FactoryGirl.create(:regional_ambassador, :approved)
    sign_in(approved_ambassador)
    expect(current_path).to eq(regional_ambassador_profile_path)
  end
end
