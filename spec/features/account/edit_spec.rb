require "rails_helper"

RSpec.feature "Edit account spec" do
  before do
    student = FactoryGirl.create(:student, email: "original@email.com",
                                           password: "secret1234")

    sign_in(student)
    click_link "My Account"
  end

  scenario "my account page shows account info" do
    expect(page).to have_content("original@email.com")
  end

  scenario "edit login info" do
    click_link "Edit"
    fill_in "Email", with: "something@else.com"
    fill_in "Existing password", with: "secret1234"

    click_button "Save"

    expect(current_path).to eq(account_path)
    expect(page).to have_content("something@else.com")
  end

  scenario "attempt to edit with wrong existing password" do
    click_link "Edit"
    fill_in "Email", with: "something@else.com"

    fill_in "Existing password", with: "wrong"
    click_button "Save"
    expect(page).to have_css(".error", text: I18n.translate("activerecord.errors.models.account.attributes.existing_password.invalid"))
  end

  scenario "attempt to edit without existing password" do
    click_link "Edit"
    fill_in "Email", with: "something@else.com"

    fill_in "Existing password", with: ""
    click_button "Save"
    expect(page).to have_css(".error", text: I18n.translate("activerecord.errors.models.account.attributes.existing_password.invalid"))
  end
end
