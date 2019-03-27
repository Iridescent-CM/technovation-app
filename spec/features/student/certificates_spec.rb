require "rails_helper"
require "fill_pdfs"

RSpec.feature "Student certificates" do
  before { SeasonToggles.display_scores_on! }

  context "virtual semifinalist students" do
    let(:student) { FactoryBot.create(:student, :virtual, :semifinalist) }

    scenario "receive a semifinalist certificate" do
      expect {
        FillPdfs.(student.account, team: student.team)
      }.to change {
        student.certificates.current.semifinalist.count
      }.from(0).to(1)

      sign_in(student)
      click_link("View your scores and certificate")

      expect(page).to have_link(
        "Open your semifinalist certificate",
        href: student.certificates.semifinalist.current.last.file_url
      )
    end

    scenario "no completion certificate is generated" do
      expect {
        FillPdfs.(student.account, team: student.team)
      }.not_to change {
        student.certificates.current.completion.count
      }
    end

    scenario "no participation certificate is generated" do
      expect {
        FillPdfs.(student.account, team: student.team)
      }.not_to change {
        student.certificates.current.participation.count
      }
    end
  end

  context "virtual quarterfinalist students" do
    let(:student) {
      FactoryBot.create(:student, :virtual, :has_qf_scores)
    }

    scenario "receive a completion certificate" do
      expect {
        FillPdfs.(student.account, team: student.team)
      }.to change {
        student.certificates.current.completion.count
      }.from(0).to(1)

      sign_in(student)
      click_link("View your scores and certificate")

      expect(page).to have_link(
        "Open your completion certificate",
        href: student.certificates.completion.current.last.file_url
      )
    end

    scenario "no participation certificate is generated" do
      expect {
        FillPdfs.(student.account, team: student.team)
      }.not_to change {
        student.certificates.current.participation.count
      }
    end
  end

  context "when the student has completed less than 50% of the submission" do
    scenario "no certificates are generated" do
      student = FactoryBot.create(:student, :incomplete_submission)

      expect {
        FillPdfs.(student.account, team: student.team)
      }.not_to change {
        student.certificates.count
      }

      sign_in(student)

      expect(page).not_to have_link("View your scores and certificate")
    end
  end

  context "when the student has completed 50-99% of the submission" do
    let(:student) { FactoryBot.create(:student, :half_complete_submission) }

    scenario "a participation certificate is generated" do
      expect {
        FillPdfs.(student.account, team: student.team)
      }.to change {
        student.certificates.current.participation.count
      }.from(0).to(1)

      sign_in(student)
      click_link( "View your certificate")

      expect(page).to have_link(
        "Open your participation certificate",
        href: student.certificates.participation.current.last.file_url
      )
    end

    scenario "no completion certificate is generated" do
      expect {
        FillPdfs.(student.account, team: student.team)
      }.not_to change {
        student.certificates.current.completion.count
      }

      sign_in(student)

      expect(page).not_to have_link("View your scores and certificate")
    end
  end
end