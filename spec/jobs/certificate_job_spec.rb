require "rails_helper"

RSpec.describe CertificateJob do
  it "fills and attaches PDFs" do
    mentor = FactoryBot.create(:mentor, :on_team, :complete_submission)
    team = mentor.current_teams.last

    expect {
      CertificateJob.perform_now(mentor.account_id, team.id)
    }.to change {
      mentor.current_appreciation_certificates.count
    }.from(0).to(1)
  end
end