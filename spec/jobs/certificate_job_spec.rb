require "rails_helper"

RSpec.describe CertificateJob do
  before {
    allow(Season).to receive(:current).and_return(Season.new(2020))
  }

  it "fills and attaches PDFs" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_team, :complete_submission)
    team = mentor.current_teams.last

    cr = CertificateRecipient.new(:mentor_appreciation, mentor.account, team: team)

    expect {
      CertificateJob.perform_later(cr.state)
    }.to change {
      mentor.current_appreciation_certificates.count
    }.from(0).to(1)
  end

  it "tracks the job in the database" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_team, :complete_submission)
    job_id = nil

    cr = CertificateRecipient.new(:mentor_appreciation, mentor.account)

    expect {
      job_id = CertificateJob.perform_later(cr.state).job_id
    }.to change {
      Job.count
    }.from(0).to(1)

    expect(Job.last.job_id).to eq(job_id)
  end

  it "adds the certificale file url to the DB job payload" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_team, :complete_submission)

    cr = CertificateRecipient.new(:mentor_appreciation, mentor.account)

    job_id = CertificateJob.perform_later(cr.state).job_id
    job = Job.find_by(job_id: job_id)

    expect(job.payload).to eq({
      "fileUrl" => mentor.current_appreciation_certificates.last.file_url,
    })
  end
end