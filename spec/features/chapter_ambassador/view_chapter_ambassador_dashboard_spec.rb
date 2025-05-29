require "rails_helper"

RSpec.feature "Chapter Ambassador Dashboard" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter) }

  before do
    sign_in(chapter_ambassador)
    click_link "Dashboard"
  end

  scenario "Viewing the Background Check tab, the Chapter Ambassador cannot complete background check onboarding task" do
    click_link "Background Check"
    expect(page).to have_content("You are not associated with a chapter or club")
  end

  scenario "Viewing the Chapter Ambassador Training tab, the Chapter Ambassador cannot complete training onboarding task" do
    click_link "Chapter Ambassador Training"
    expect(page).to have_content("You are not associated with a chapter.")
  end

  scenario "Viewing the Chapter Volunteer Agreement tab, the Chapter Ambassador cannot complete legal agreement onboarding task" do
    click_link "Chapter Volunteer Agreement"
    expect(page).to have_content("You are not associated with a chapter.")
  end

  scenario "Viewing Community Connections tab, the Chapter Ambassador cannot complete community connections onboarding task" do
    click_link "Community Connections"
    expect(page).to have_content("You are not associated with a chapter.")
  end
end
