require "rails_helper"

RSpec.feature "Mentor personal summary" do
  let(:mentor) { FactoryBot.create(:mentor, :onboarded) }

  before do
    sign_in(mentor)
  end

  scenario "displays 'Add your summary' button when personal summary is missing" do
    mentor.bio = nil
    mentor.save

    visit mentor_dashboard_path
    click_link "Personal Summary"

    expect(page).to have_link("Add your summary", href: edit_mentor_bio_path)
  end

  scenario "displays existing summary and 'Change your summary' button when personal summary is present" do
    visit mentor_dashboard_path
    click_link "Personal Summary"

    expect(page).to have_link("Change your summary", href: edit_mentor_bio_path)
    expect(page).to have_content(mentor.bio)
  end

  scenario "allows mentor to update their personal summary" do
    visit mentor_dashboard_path
    click_link "Personal Summary"
    click_link "Change your summary"

    fill_in "Tell the students about yourself", with: "Lorem ipsum dolor sit amet,
      consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore."

    click_button "Save"
    expect(current_path).to eq(mentor_dashboard_path)
  end
end
