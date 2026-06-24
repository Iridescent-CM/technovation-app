require "rails_helper"

RSpec.describe CertificateJob do
  include Rails.application.routes.url_helpers

  let(:season_with_templates) { instance_double(Season, year: 2020) }
  before do
    allow(Season).to receive(:current).and_return(season_with_templates)
  end

  it "creates certificate records" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_team, :complete_submission)
    team = mentor.current_teams.last

    cr = CertificateRecipient.new(:mentor, mentor.account, team: team)

    expect {
      CertificateJob.perform_later(cr.state)
    }.to change {
      mentor.current_appreciation_certificates.count
    }.from(0).to(1)
  end

  it "tracks the job in the database" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_team, :complete_submission)
    job_id = nil

    cr = CertificateRecipient.new(:mentor, mentor.account)

    expect {
      job_id = CertificateJob.perform_later(cr.state).job_id
    }.to change {
      Job.count
    }.from(0).to(1)

    expect(Job.last.job_id).to eq(job_id)
  end

  it "adds the certificate download path to the DB job payload" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_team, :complete_submission)
    team = mentor.current_teams.last

    cr = CertificateRecipient.new(:mentor, mentor.account, team: team)

    job_id = CertificateJob.perform_later(cr.state).job_id
    job = Job.find_by(job_id: job_id)
    cert = mentor.current_appreciation_certificates.last

    expect(job.payload).to eq({
      "fileUrl" => certificate_download_path(cert)
    })
  end
end
