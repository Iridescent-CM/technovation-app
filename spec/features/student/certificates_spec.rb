require "rails_helper"

RSpec.feature "Student certificates" do
  before do
    @original_certificates = ENV["CERTIFICATES"]
    ENV["CERTIFICATES"] = "a truthy value -- booleans don't work"
    SeasonToggles.display_scores="yes"
  end

  after do
    if @original_certificates.blank?
      ENV.delete("CERTIFICATES")
    end
  end

  scenario "generate a completion cert" do
    skip "Rebuilding student dashboard: certs not back yet"

    student = FactoryGirl.create(:student, :on_team)
    FactoryGirl.create(:team_submission, team: student.team)

    sign_in(student)

    within("#student_completion_cert") {
      click_button("Prepare my certificate")
    }

    expect(page).to have_link("Download my certificate",
                              href: student.certificates.current.file_url)
  end

  scenario "generate a regional grand prize cert" do
    skip "Rebuilding student dashboard: certs not back yet"

    student = FactoryGirl.create(:student, :on_team)

    rpe = FactoryGirl.create(:rpe)
    rpe.teams << student.team

    student.team.team_submissions.create!(
      integrity_affirmed: true,
      contest_rank: :semifinalist
    )

    sign_in(student)

    within("#student_winner_cert") {
      click_button("Prepare my certificate")
    }

    expect(page).to have_link(
      "Download my certificate",
      href: student.certificates.rpe_winner.current.file_url
    )
  end
end
