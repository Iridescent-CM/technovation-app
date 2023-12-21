require "rails_helper"

RSpec.feature "Manage admin accounts" do
  scenario "admins are unable to invite a new admin" do
    sign_in(:admin)
    click_link "Admins"
    expect(page).to_not have_link("Setup a new admin")
  end

  scenario "admins are unable to delete an admin" do
    sign_in(:admin)
    click_link "Admins"
    expect(page).to_not have_link("delete")
  end

  scenario "super admins can invite a new admin to signup via email" do
    ActionMailer::Base.deliveries.clear

    sign_in(:admin, :super_admin)

    click_link "Admins"
    click_link "Setup a new admin"

    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "Sak"
    fill_in "Email", with: "joe@iridescentlearning.org"

    expect {
      click_button "Invite"
    }.to change {
      Account.temporary_password.count
    }.from(0).to(1)
      .and change {
             ActionMailer::Base.deliveries.count
           }.from(0).to(1)

    new_admin = Account.temporary_password.last
    visit admin_signup_path(token: new_admin.admin_invitation_token)

    password = SecureRandom.hex(10)
    fill_in "Password", with: password

    click_button "Save"

    expect(current_path).to eq(admin_dashboard_path)

    click_link "Logout"

    visit signin_path

    fill_in "Email", with: "joe@iridescentlearning.org"
    fill_in "Password", with: password

    click_button "Sign in"

    expect(current_path).to eq(admin_dashboard_path)
  end

  scenario "Delete button is not available if there is only 1 admin with full_admin status" do
    sign_in(:admin, :super_admin)
    click_link "Admins"
    expect(page).to_not have_link("delete")
  end

  scenario "Only super admins can delete admins" do
    admin = FactoryBot.create(:admin)
    super_admin = FactoryBot.create(:admin, :super_admin)

    sign_in(:super_admin)
    click_link "Admins"

    expect(page).to have_link("delete")
    click_link "delete", href: "/admin/admins/#{admin.account_id}"
    expect(page).to have_content("You deleted #{admin.name}")
  end

  scenario "Admins are not able to make super admins" do
    sign_in(:admin)
    click_link "Admins"
    expect(page).to_not have_link("make super admin")
  end

  scenario "Only super admins can make super admins" do
    admin = FactoryBot.create(:admin)
    super_admin = FactoryBot.create(:admin, :super_admin)

    sign_in(super_admin)
    click_link "Admins"
    expect(page).to have_link("make super admin")
  end
end
