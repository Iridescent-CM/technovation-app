require "rails_helper"

RSpec.feature "Student certificates" do
  before do
    @original_certificates = ENV["CERTIFICATES"]
    @original_scores = ENV["ENABLE_TEAM_SCORES"]
    ENV["CERTIFICATES"] = "a truthy value -- booleans don't work"
    ENV["ENABLE_TEAM_SCORES"] = "truthy"
  end

  after do
    if @original_certificates.blank?
      ENV.delete("CERTIFICATES")
    end

    if @original_scores.blank?
      ENV.delete("ENABLE_TEAM_SCORES")
    end
  end

  scenario "generate a completion cert" do
    student = FactoryGirl.create(:student, :on_team)
    FactoryGirl.create(:team_submission, team: student.team)

    sign_in(student)

    click_button("Prepare my participation certificate")

    expect(page).to have_link("Download my Participation Certificate",
                              href: student.certificates.current.file_url)
  end

  scenario "generate a regional grand prize cert" do
    student = FactoryGirl.create(:student, :on_team)

    rpe = FactoryGirl.create(:rpe)
    rpe.teams << student.team

    student.team.team_submissions.create!(integrity_affirmed: true, contest_rank: :semifinalist)

    sign_in(student)

    click_button("Prepare my regional winner's certificate")

    expect(page).to have_link("Download my Regional Winner's Certificate",
                              href: student.certificates.rpe_winner.current.file_url)
  end
end
