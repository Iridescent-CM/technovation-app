require "rails_helper"

RSpec.feature "Admins managing chapters", :js do
  before do
    sign_in(:admin)
  end

  scenario "Admin add a chapter" do
    visit admin_chapters_path
    click_link "Setup a new chapter"

    fill_in "organization_name", with: "Hello World"
    expect(page).to have_field("organization_name", with: "Hello World")

    click_button "Add"

    expect(page).to have_content("Hello World")
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
