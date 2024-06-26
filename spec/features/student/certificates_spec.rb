require "rails_helper"
require "fill_pdfs"

RSpec.feature "Student certificates" do
  before do
    SeasonToggles.display_scores_on!
    SeasonToggles.set_survey_link(:student, "Hello World", "https://google.com")
  end

  let(:season_with_templates) { instance_double(Season, year: 2020) }
  before { allow(Season).to receive(:current).and_return(season_with_templates) }

  context "virtual semifinalist students" do
    let(:student) { FactoryBot.create(:student, :virtual, :semifinalist) }

    scenario "receive a semifinalist certificate" do
      expect {
        FillPdfs.call(student.account)
      }.to change {
        student.certificates.current.semifinalist.count
      }.from(0).to(1)

      student.account.took_program_survey!
      sign_in(student)

      expect(page).to have_content("Congratulations, your team was a semifinalist!")

      click_link("View your scores and certificate")
    end

    scenario "no quarterfinalist certificate is generated" do
      expect {
        FillPdfs.call(student.account)
      }.not_to change {
        student.certificates.current.quarterfinalist.count
      }
    end

    scenario "no participation certificate is generated" do
      expect {
        FillPdfs.call(student.account)
      }.not_to change {
        student.certificates.current.participation.count
      }
    end
  end

  context "virtual quarterfinalist students" do
    let(:student) {
      FactoryBot.create(:student, :virtual, :has_qf_scores)
    }

    scenario "receive a quarterfinalist certificate" do
      expect {
        FillPdfs.call(student.account)
      }.to change {
        student.certificates.current.quarterfinalist.count
      }.from(0).to(1)

      student.account.took_program_survey!
      sign_in(student)

      expect(page).to have_content("Congratulations, your team was a quarterfinalist!")

      click_link("View your scores and certificate")
      expect(page).to have_content("Congratulations, your team was a quarterfinalist!")
      expect(page).to have_content("#Technovation#{Season.current.year}Alumna")

      click_link("Certificates")
      expect(page).to have_link(
        "Open your quarterfinalist certificate",
        href: student.certificates.quarterfinalist.current.last.file_url
      )
    end

    scenario "no participation certificate is generated" do
      expect {
        FillPdfs.call(student.account)
      }.not_to change {
        student.certificates.current.participation.count
      }
    end
  end

  context "when the student has completed less than 50% of the submission" do
    scenario "no certificates are generated" do
      student = FactoryBot.create(:student, :incomplete_submission)

      expect {
        FillPdfs.call(student.account)
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
        FillPdfs.call(student.account)
      }.to change {
        student.certificates.current.participation.count
      }.from(0).to(1)

      student.account.took_program_survey!
      sign_in(student)

      expect(page).to have_content("Thank you for participating this season! Click the button below to view your scores and certificate.")

      click_link("View your scores and certificate")

      expect(page).to have_content("Thank you for being part of Technovation Girls! No scores are available since your project submission was incomplete.")

      click_link("Certificates")
      expect(page).to have_link(
        "Open your participation certificate",
        href: student.certificates.participation.current.last.file_url
      )
    end

    scenario "no quarterfinalist certificate is generated" do
      expect {
        FillPdfs.call(student.account)
      }.not_to change {
        student.certificates.current.quarterfinalist.count
      }

      sign_in(student)

      expect(page).not_to have_link("View your scores and certificate")
    end
  end

  context "when the student has received two certificates" do
    let(:student) { FactoryBot.create(:student, :virtual, :on_team, :semifinalist) }

    before {
      FactoryBot.create(:certificate,
        account: student.account,
        team: student.team,
        cert_type: :quarterfinalist)

      FactoryBot.create(:certificate,
        account: student.account,
        team: student.team,
        cert_type: :semifinalist)
    }

    scenario "the highest certificate is displayed" do
      expect(student.certificates.current.quarterfinalist.count).to eq(1)
      expect(student.certificates.current.semifinalist.count).to eq(1)

      student.account.took_program_survey!
      sign_in(student)

      expect(page).to have_content("Congratulations, your team was a semifinalist!")

      click_link("View your scores and certificate")
      expect(page).to have_content("Congratulations, your team was a semifinalist!")

      click_link("Certificates")

      expect(page).to have_link(
        "Open your semifinalist certificate"
      )
    end
  end
end
