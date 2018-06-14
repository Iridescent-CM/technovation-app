require "rails_helper"

RSpec.feature "Mentor certificates" do
  before  { SeasonToggles.display_scores_on! }

  scenario "generate an appreciation cert" do
    mentor = FactoryBot.create(:mentor, number_of_teams: 5)

    expect {
      sign_in(mentor)
    }.to change {
      mentor.current_appreciation_certificates.count
    }.from(0).to(5)

    mentor.current_teams.each do |team|
      expect(page).to have_link(
        "Open your certificate",
        href: mentor.current_appreciation_certificates.find_by(team_id: team.id).file_url
      )
    end
  end

  scenario "no certificates for no teams" do
    mentor = FactoryBot.create(:mentor)
    sign_in(mentor)
    expect(page).not_to have_link("Open your certificate")
  end
end
