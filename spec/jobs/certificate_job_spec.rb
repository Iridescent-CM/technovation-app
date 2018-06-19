require "rails_helper"

RSpec.describe CertificateJob do
  it "fills and attaches PDFs" do
    mentor = FactoryBot.create(:mentor, :on_team, :complete_submission)
    team = mentor.current_teams.last

    expect {
      CertificateJob.perform_later(mentor.account_id, team.id)
    }.to change {
      mentor.current_appreciation_certificates.count
    }.from(0).to(1)
  end

  it "tracks the job in the database" do
    mentor = FactoryBot.create(:mentor, :on_team, :complete_submission)
    job_id = nil

    expect {
      job_id = CertificateJob.perform_later(mentor.account_id).job_id
    }.to change {
      Job.count
    }.from(0).to(1)

    expect(Job.last.job_id).to eq(job_id)
  end
end