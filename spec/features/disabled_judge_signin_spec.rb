require "rails_helper"

RSpec.feature "Disabled judge sign-ins" do
  scenario "an existing judge sees a splash page about applying coming soon" do
    judge = FactoryGirl.create(:judge)

    sign_in(judge)

    expect(current_path).to eq(judge_dashboard_path)

    expect(page).to have_content("The judging section is not currently available")

    expect(page).to have_content(
      "Technovation is changing how we are doing judging this year."
    )

    expect(page).to have_content(
      "Stay tuned for more details."
    )

    expect(page).to have_content(
      "We will email you when updates are ready, and you can apply to be a judge."
    )

    expect(page).to have_link("My profile", judge_profile_path)
    expect(page).to have_link("Logout", logout_path)
  end
end
