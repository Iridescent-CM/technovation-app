require "rails_helper"

RSpec.feature "Admins view Chapter Ambassador participant details" do
  scenario "when Chapter Ambassador is assigned to a chapter, chapter name and organization are displayed" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, :assigned_to_chapter)
    chapter = chapter_ambassador.account.current_chapter

    sign_in(:admin)

    click_link "Participants"
    within("tr#account_#{chapter_ambassador.account_id}") { click_link "view" }

    expect(current_path).to eq(admin_participant_path(chapter_ambassador.account))

    expect(page).to have_content "Chapter (Program name)"
    expect(page).to have_link chapter.name, href: admin_chapter_path(chapter)
    expect(page).to have_content "Chapter Organization"
    expect(page).to have_content "#{chapter.organization_name}"
  end

  scenario "when Chapter Ambassador is not assigned to a chapter, chapter name and organization are not displayed" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter)

    sign_in(:admin)

    click_link "Participants"
    within("tr#account_#{chapter_ambassador.account_id}") { click_link "view" }

    expect(current_path).to eq(admin_participant_path(chapter_ambassador.account))

    expect(page).to have_content "Chapter"
    expect(page).to have_content "Not assigned to a chapter"
  end
end

