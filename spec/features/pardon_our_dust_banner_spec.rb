require "rails_helper"

RSpec.feature "Platform move banner", js: true do
  scenario "student sees banner on dashboard, can dismiss it, and it stays hidden on revisit" do
    student = FactoryBot.create(:student, :onboarded)
    sign_in(student)

    page.execute_script("localStorage.setItem('pardon_our_dust_banner_dismissed', 'true')")
    page.execute_script("localStorage.removeItem('platform_moved_banner_dismissed')")
    visit student_dashboard_path

    expect(page).to have_css("[aria-label='Site announcement']")
    expect(page).to have_text("Technovation has upgraded!")
    expect(page).to have_text("Your platform has a new home! Active season tools are no longer functional on this site.")
    expect(page).to have_text("Please update your bookmarks and continue your Technovation journey on the new site.")
    expect(page).to have_link("Take me to the new platform →", href: "https://my.technovation.org/")

    find("[aria-label='Dismiss announcement']").click

    expect(page).not_to have_css("[aria-label='Site announcement']")

    visit student_dashboard_path

    expect(page).not_to have_css("[aria-label='Site announcement']")
    expect(page).not_to have_text("Technovation has upgraded!")
  end
end
