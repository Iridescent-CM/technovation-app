require "rails_helper"

RSpec.feature "Admins managing chapters", :js do
  before do
    sign_in(:admin)
  end

  scenario "Admin add a chapter" do
    click_link "Chapters"
    click_link "Setup a new chapter"

    fill_in "Organization name", with: "Hello World"
    click_button "Add"

    expect(page).to have_content(Chapter.last.organization_name)
    expect(page).to have_content("Please use the invite button below to invite a user to be the Chapter Ambassador for this chapter.")
    expect(Chapter.count).to eq(1)
  end

  scenario "Admin view all chapters" do
    chapters = FactoryBot.create_list(:chapter, 2)
    visit admin_chapters_path

    chapters.each do |chapter|
      expect(page).to have_selector("tr#chapter_#{chapter.id}")
      within("tr#chapter_#{chapter.id}") do
        expect(page).to have_link(chapter.name, href: admin_chapter_path(chapter))
        expect(page).to have_css("td.organization_name", text: chapter.organization_name)
      end
    end
  end
end
