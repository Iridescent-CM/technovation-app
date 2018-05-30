require "rails_helper"

RSpec.feature "Mentor certificates" do
  before  { SeasonToggles.display_scores_on! }

  scenario "generate an appreciation cert" do
    skip "Unskip mentor certficates specs ASAP"

    mentor = FactoryBot.create(:mentor, :on_team)

    sign_in(mentor)

    within("#cert_appreciation") { click_button("Prepare my certificate") }

    expect(page).to have_link(
      "Download my certificate",
      href: mentor.certificates.appreciation.current.file_url
    )
  end
end
