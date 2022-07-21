require "rails_helper"

RSpec.feature "Judging open splash page" do
  scenario "Judging is set to QF and judge registration is enabled" do
    SeasonToggles.set_judging_round(:qf)
    SeasonToggles.enable_signup(:judge)

    visit root_path
    expect(page).not_to have_css("#registration-landing")
    expect(page).to have_content("Registration is currently open for judges")
    expect(page).to have_content("Registration is currently closed for students and mentors")
  end

  scenario "Judging is set to QF and judge registration is disabled" do
    SeasonToggles.set_judging_round(:qf)
    SeasonToggles.disable_signups!

    visit root_path
    expect(page).not_to have_css("#registration-landing")
    expect(page).to have_content("Judging is open")
    expect(page).to have_content("Registration is currently closed for students and mentors")
  end
end
