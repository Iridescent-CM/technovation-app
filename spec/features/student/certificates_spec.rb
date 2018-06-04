require "rails_helper"

RSpec.feature "Student certificates" do
  before { SeasonToggles.display_scores_on! }

  context "quarterfinalist students" do
    let(:student) { FactoryBot.create(:student, :quarterfinalist) }

    scenario "receive a completion certificate" do
      expect {
        sign_in(student)
      }.to change {
        student.certificates.current.completion.count
      }.from(0).to(1)

      click_link("View your scores and certificates")

      expect(page).to have_link(
        "View your certificate",
        href: student.certificates.completion.current.last.file_url
      )
    end

    scenario "no participation certificate is generated" do
      expect {
        sign_in(student)
      }.not_to change {
        student.certificates.current.participation.count
      }
    end
  end

  context "when the student has completed less than 50% of the submission" do
    scenario "no certificates are generated" do
      student = FactoryBot.create(:student, :incomplete_submission)

      expect {
        sign_in(student)
      }.not_to change {
        student.certificates.count
      }

      expect(page).not_to have_link("View your scores and certificates")
    end
  end

  scenario "generate a regional grand prize cert" do
    skip "for now"
    student = FactoryBot.create(:student, :on_team)

    rpe = FactoryBot.create(:rpe)
    rpe.teams << student.team

    FactoryBot.create(
      :team_submission,
      team: student.team,
      contest_rank: :semifinalist,
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
