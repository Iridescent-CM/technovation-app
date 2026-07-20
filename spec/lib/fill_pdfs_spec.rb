require "rails_helper"
require "fill_pdfs"

RSpec.describe FillPdfs do
  let(:season_2026) { instance_double(Season, year: 2026) }

  before do
    allow(Season).to receive(:current).and_return(season_2026)
  end

  it "does not run twice for accounts with current certs of the detected type" do
    student = FactoryBot.create(:student, :quarterfinalist)
    FactoryBot.create(:certificate,
      cert_type: :quarterfinalist,
      account: student.account,
      team: student.team)

    expect {
      FillPdfs.call(student.account)
    }.not_to change {
      student.certificates.current.quarterfinalist.count
    }
  end

  it "does not generate a certificate for onboarding judges" do
    judge = FactoryBot.create(:judge)

    expect {
      FillPdfs.call(judge.account)
    }.not_to change {
      judge.certificates.count
    }
  end

  def pdf_text(path)
    PDF::Reader.new(path).pages.map(&:text).join(" ").squish
  end

  # Flattened letter form fields often extract without spaces between words.
  def pdf_text_compact(path)
    pdf_text(path).gsub(/\s+/, "")
  end

  it "fills the recipient name on mentor letters from the design Text Field" do
    mentor = FactoryBot.create(:mentor, :complete_submission, number_of_teams: 1)
    recipient = CertificateRecipient.new(:mentor_letter, mentor.account)
    tmp_path = "./tmp/#{season_2026.year}-mentor_letter-#{mentor.account.id}-.pdf"

    FillPdfs.fill(recipient)

    expect(pdf_text_compact(tmp_path)).to include(mentor.account.name.gsub(/\s+/, ""))
    expect(mentor.account.current_mentor_letter_certificates).to exist
  end

  it "fills the recipient name and country on club ambassador letters" do
    ambassador = FactoryBot.create(:club_ambassador)
    ambassador.update_column(:onboarded, true)
    ambassador.account.current_clubs.first.update_column(:onboarded, true)
    recipient = CertificateRecipient.new(:ambassador_letter, ambassador.account)
    tmp_path = "./tmp/#{season_2026.year}-ambassador_letter-#{ambassador.account.id}-.pdf"

    FillPdfs.fill(recipient)

    country = FriendlyCountry.call(ambassador.account, prefix: false).strip
    compact = pdf_text_compact(tmp_path)

    expect(compact).to include(ambassador.account.name.gsub(/\s+/, ""))
    # PDF::Reader often drops spaces; assert country sits between "in" and "for the".
    expect(compact).to match(
      /in#{Regexp.escape(country.gsub(/\s+/, ""))}fortheTechnovationGirls/i
    )
  end

  it "uses the first Club Ambassador page (name + Country) for club ambassadors" do
    ambassador = FactoryBot.create(:club_ambassador)
    recipient = CertificateRecipient.new(:ambassador_letter, ambassador.account)

    expect(CertificateTemplatePaths.for(recipient: recipient, type: :ambassador_letter, season: 2026))
      .to eq("./lib/certs/2026/club_ambassador_letter.pdf")
  end
end
