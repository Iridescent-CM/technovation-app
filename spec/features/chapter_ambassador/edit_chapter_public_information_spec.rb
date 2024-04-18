require "rails_helper"

RSpec.feature "Chapter ambassadors edit public chapter information" do
  let(:chapter) { FactoryBot.create(:chapter) }

  before do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, chapter: chapter)
    sign_in(chapter_ambassador)
    click_link "Chapter Profile"
    click_link "Public Info"
  end

  scenario "Chapter ambassador edits their public chapter information" do
    click_link "Update chapter public info"

    expect(page).to have_checked_field('chapter_visible_on_map_true')

    fill_in "chapter_name", with: "Chapter Legoland"
    fill_in "chapter_summary", with: "Hello this is our awesome chapter!"
    click_button "Save"

    expect(page).to have_content "Chapter Legoland"
    expect(page).to have_content "Hello this is our awesome chapter!"
  end

  scenario "Chapter ambassador changes their public chapter visibility status to 'do not display'" do
    expect(page).to have_content "This chapter is displayed on the map of chapters on the Technovation website"
    click_link "Update chapter public info"

    choose("chapter_visible_on_map_false")
    click_button "Save"

    expect(page).to have_content "This chapter is not displayed on the map of chapters on the Technovation website"
  end
end
