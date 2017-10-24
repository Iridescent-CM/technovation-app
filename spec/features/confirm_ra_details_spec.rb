require "rails_helper"
require "./lib/invite_ra"

RSpec.feature "Invited RAs confirm their details" do
  let(:attempt) {
    InviteRA.(
      FactoryGirl.attributes_for(:account).merge(
        FactoryGirl.attributes_for(:ambassador)
      )
    )
  }

  scenario "RAs must enter a new password" do
    visit signup_path(admin_permission_token: attempt.admin_permission_token)

    click_button "Create Your Account"

    expect(current_path).not_to eq(regional_ambassador_dashboard_path)
    expect(page).to have_css(".password + .error")

    fill_in "Create a password", with: "short"
    click_button "Create Your Account"

    expect(current_path).not_to eq(regional_ambassador_dashboard_path)
    expect(page).to have_css(".password + .error")

    fill_in "Create a password", with: "nottooshort"
    click_button "Create Your Account"

    expect(current_path).to eq(regional_ambassador_dashboard_path)
  end
end
