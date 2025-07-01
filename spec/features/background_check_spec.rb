require "rails_helper"

RSpec.feature "background checks", js: true do
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
        date_of_birth: age.years.ago,
        meets_minimum_age_requirement: true
      )

      sign_in(mentor)

      expect(page).not_to have_link("Submit Background Check")
    end

    scenario "mentors age #{age} does not become searchable" do
      mentor = FactoryBot.create(
        :mentor,
        :geocoded,
        not_onboarded: true,
        date_of_birth: age.years.ago,
        meets_minimum_age_requirement: false,
        bio: ""
      )

      sign_in(mentor)

      visit mentor_training_completion_path
      click_link "Consent Waiver"
      click_link "Sign Consent Waiver"

      check "read_and_understands_code_of_conduct"
      check "acknowledges_consequences_of_code_of_conduct"
      fill_in "consent_waiver_electronic_signature", with: "My sig"
      click_button "I agree"

      visit mentor_bio_path
      click_link "Add your summary"
      fill_in "mentor_profile_bio",
        with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " \
          "Praesent luctus dapibus lacus vitae interdum. " \
          "Praesent lacinia accumsan ligula, sit amet ultrices " \
          "velit venenatis id. Duis ac nibh euismod, " \
          "porta risus ut, molestie tortor."
      click_button "Save"

      expect(mentor.reload).not_to be_searchable
    end
  end
end
