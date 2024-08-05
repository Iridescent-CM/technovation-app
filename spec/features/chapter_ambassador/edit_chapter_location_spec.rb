require "rails_helper"

RSpec.feature "Chapter ambassadors edit chapter location" do
  let(:chapter) { FactoryBot.create(:chapter) }

  before do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, chapter: chapter)
    sign_in(chapter_ambassador)
    click_link "Chapter Profile"
    click_link "Chapter Location"
  end

  scenario "Chapter ambassador edits organization headquarters location" do
    click_link "Update organization headquarters"

    fill_in "chapter_organization_headquarters_location", with: "123 Main St, USA"
    click_button "Save"

    expect(page).to have_css(".flash.flash--success", text: "You updated your chapter location details!")
    expect(page).to have_content "123 Main St, USA"
  end
end
