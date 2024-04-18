require "rails_helper"

RSpec.feature "Chapter Ambassadors can click on chapter profile tab" do
  let(:chapter) { FactoryBot.create(:chapter) }

  scenario "All Chapter Details links are visible in the side navigation" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, chapter: chapter)
    sign_in(chapter_ambassador)

    click_link "Chapter Profile"

    within("#tab-wrapper") do
      expect(page).to have_link("Public Info")
      expect(page).to have_link("Chapter Location")
      expect(page).to have_link("Program Info")
    end
  end

  scenario "A Chapter Ambassador assigned to a chapter can view chapter public information" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, chapter: chapter)
    sign_in(chapter_ambassador)

    click_link "Chapter Profile"
    click_link "Public Info"

    expect(page).to have_content(chapter.organization_name)
    expect(page).to have_content(chapter.name)
    expect(page).to have_content("Please select a primary contact")
    expect(page).to have_content("This chapter is displayed on the map of chapters on the Technovation website")
  end

  scenario "A Chapter Ambassador not assigned to a chapter does not see chapter public information" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador)
    sign_in(chapter_ambassador)

    click_link "Chapter Profile"
    click_link "Public Info"

    expect(page).to have_content("You are not associated with a chapter.")
  end
end
