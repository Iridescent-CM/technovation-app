require "rails_helper"

RSpec.feature "Mentor certificates" do
  before  { SeasonToggles.display_scores_on! }

  scenario "no certificates for no teams" do
    mentor = FactoryBot.create(:mentor)
    sign_in(mentor)
    expect(page).not_to have_link("Open your certificate")
  end
end
