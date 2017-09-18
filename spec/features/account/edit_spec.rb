require "rails_helper"

RSpec.feature "Edit account spec" do
  before do
    student = FactoryGirl.create(
      :student,
      email: "original@email.com",
      password: "secret1234"
    )

    sign_in(student)
    visit student_profile_path
  end

  scenario "my account page shows account info" do
    expect(page.find("[type=email]").value).to eq("original@email.com")
  end

  scenario "edit geocoded info" do
    click_link "Change your location"

    expect(page).to have_css('input[value="Chicago"]')

    fill_in "City", with: "Los Angeles"
    fill_in "State / Province", with: "CA"
    click_button "Save"

    expect(StudentProfile.last.city).to eq("Los Angeles")
  end

  scenario "attempt to edit with wrong existing password" do
    within("#change-password") do
      fill_in "Change your password", with: "something@else.com"

      fill_in "Current password", with: "wrong"
      click_button "Save"
    end

    expect(page).to have_css(
      ".error",
      text: I18n.translate(
        "activerecord.errors.models.account.attributes.existing_password.invalid"
      )
    )
  end

  scenario "attempt to edit without existing password" do
    within("#change-password") do
      fill_in "Change your password", with: "something@else.com"

      fill_in "Current password", with: ""
      click_button "Save"
    end

    expect(page).to have_css(
      ".error",
      text: I18n.translate(
        "activerecord.errors.models.account.attributes.existing_password.blank"
      )
    )
  end

  scenario "edit profile info" do
    click_link "Change your basic profile details"
    fill_in "School name", with: "New School"

    click_button "Save"
    expect(current_path).to eq(student_profile_path)
    expect(page).to have_content("New School")
  end

  %i{mentor regional_ambassador}.each do |scope|
    scenario "edit #{scope} bio" do
      sign_out
      profile = FactoryGirl.create(scope)

      sign_in(profile)
      visit send("#{scope}_profile_path")

      click_link "Change your basic profile details"

      fill_in "#{scope}_profile[bio]",
        with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."

      click_button "Save"

      expect(page).to have_css(
        'dd',
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."
      )
    end
  end
end
