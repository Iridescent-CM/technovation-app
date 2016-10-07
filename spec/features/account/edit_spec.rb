require "rails_helper"

RSpec.feature "Edit account spec" do
  before do
    student = FactoryGirl.create(:student, email: "original@email.com",
                                           password: "secret1234")

    sign_in(student)
    click_link "My account"
  end

  scenario "my account page shows account info" do
    expect(page).to have_content("original@email.com")
  end

  scenario "edit geocoded info" do
    click_link "Edit"

    expect(page).to have_css('input[value="Chicago, IL, United States"]')

    fill_in "Postal code -OR- City & State/Province", with: "Los Angeles, CA"
    click_button "Save"

    expect(StudentAccount.last.city).to eq("Los Angeles")
  end

  scenario "attempt to edit with wrong existing password" do
    click_link "Edit"
    fill_in "Password", with: "something@else.com"

    fill_in "Current password", with: "wrong"
    click_button "Save"
    expect(page).to have_css(".error", text: I18n.translate("activerecord.errors.models.student_account.attributes.existing_password.invalid"))
  end

  scenario "attempt to edit without existing password" do
    click_link "Edit"
    fill_in "Password", with: "something@else.com"

    fill_in "Current password", with: ""
    click_button "Save"
    expect(page).to have_css(".error", text: I18n.translate("activerecord.errors.models.student_account.attributes.existing_password.invalid"))
  end

  scenario "edit profile info" do
    click_link "Edit"
    fill_in "School name", with: "New School"

    click_button "Save"
    expect(current_path).to eq(student_account_path)
    expect(page).to have_content("New School")
  end

  scenario "edit bio" do
    sign_out
    account = FactoryGirl.create(%i{mentor regional_ambassador}.sample)

    sign_in(account)
    visit send("edit_#{account.type_name}_account_path")

    fill_in "#{account.type_name}_account[#{account.type_name}_profile_attributes][bio]", with: "Check out my random cool bio!!!!"
    click_button "Save"

    expect(page).to have_css('dd', text: "Check out my random cool bio!!!!")
  end
end
