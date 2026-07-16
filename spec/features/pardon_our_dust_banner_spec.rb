require "rails_helper"

RSpec.feature "Pardon our dust banner", js: true do
  scenario "student sees banner on dashboard, can dismiss it, and it stays hidden on revisit" do
    student = FactoryBot.create(:student, :onboarded)
    sign_in(student)

    page.execute_script("localStorage.removeItem('pardon_our_dust_banner_dismissed')")
    visit student_dashboard_path

    expect(page).to have_css("[aria-label='Site announcement']")
    expect(page).to have_text("Pardon our dust!")
    expect(page).to have_text("Technovation's refreshed brand and broadened mission are live at technovation.org.")
    expect(page).to have_link("See what's new →", href: "https://www.technovation.org/")

    find("[aria-label='Dismiss announcement']").click

    expect(page).not_to have_css("[aria-label='Site announcement']")

    visit student_dashboard_path

    expect(page).not_to have_css("[aria-label='Site announcement']")
    expect(page).not_to have_text("Pardon our dust!")
  end
end
