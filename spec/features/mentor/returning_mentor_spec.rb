require "rails_helper"

RSpec.feature "Returning mentor" do
  scenario "asked to select their mentor_type" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    mentor.update_column(:mentor_type, nil)

    sign_in(mentor)

    expect(page).to have_content("Please let us know what type of mentor you are")
    select "Educator", from: "Choose your mentor type"
    click_button "Save"

    expect(mentor.reload.mentor_type).to eq("Educator")
  end
end