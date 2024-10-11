require "rails_helper"

RSpec.feature "background checks" do
  scenario "mentors not located in the US, India, or Canada do not see a link to submit a background check" do
    mentor = FactoryBot.create(
      :mentor,
      :brazil
    )

    sign_in(mentor)

    expect(page).not_to have_link("Submit Background Check")
  end

  [16, 17].each do |age|
    scenario "mentors age #{age} do not need to complete one" do
      mentor = FactoryBot.create(
        :mentor,
        :geocoded,
        date_of_birth: age.years.ago
      )

      sign_in(mentor)

      expect(page).not_to have_link("Submit Background Check")
    end

    scenario "mentors age #{age} still become searchable" do
      mentor = FactoryBot.create(
        :mentor,
        :geocoded,
        not_onboarded: true,
        date_of_birth: age.years.ago,
        bio: ""
      )

      sign_in(mentor)

      visit mentor_training_completion_path
      click_link "Sign Consent Waiver"
      fill_in "consent_waiver_electronic_signature", with: "My sig"
      click_button "I agree"

      fill_in "mentor_profile_bio",
        with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
          "Praesent luctus dapibus lacus vitae interdum. " +
          "Praesent lacinia accumsan ligula, sit amet ultrices " +
          "velit venenatis id. Duis ac nibh euismod, " +
          "porta risus ut, molestie tortor."
      within("[slot=bio]") { click_button "Save" }

      expect(mentor.reload).to be_searchable
    end
  end
end
