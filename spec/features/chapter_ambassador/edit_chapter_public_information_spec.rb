require "rails_helper"

RSpec.feature "Chapter ambassadors edit public chapter information" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
  let(:chapter) { FactoryBot.create(:chapter, primary_contact: chapter_ambassador.account) }

  before do
    sign_in(chapter_ambassador)
    click_link "Chapter Profile"
    click_link "Public Info"
  end

  scenario "Chapter ambassador edits chapter name and adds a 680 character chapter summary" do
    valid_length_text = "Hello this is our awesome chapter!" * 20

    click_link "Update chapter public info"

    expect(page).to have_checked_field("chapter_visible_on_map_true")

    fill_in "chapter_name", with: "Chapter Legoland"
    fill_in "chapter_summary", with: valid_length_text
    click_button "Save"

    expect(page).to have_content "Chapter Legoland"
    expect(page).to have_content(valid_length_text)
  end

  scenario "Chapter ambassador saves a chapter summary longer than 1000 characters" do
    invalid_length_text = "Lorem ipsum dolor " * 90

    click_link "Update chapter public info"

    fill_in "chapter_summary", with: invalid_length_text
    click_button "Save"

    expect(page).to have_css(".flash.flash--alert", text: "Error updating chapter details.")
  end

  scenario "Chapter ambassador changes their public chapter visibility status to 'do not display'" do
    expect(page).to have_content "This chapter is displayed on the map of chapters on the Technovation website"
    click_link "Update chapter public info"

    choose("chapter_visible_on_map_false")
    click_button "Save"

    expect(page).to have_content("This chapter is not displayed on the map of chapters on the Technovation website")
  end
end
