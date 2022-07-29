require "rails_helper"
require "fill_pdfs"

RSpec.describe FillPdfs do
  it "does not run twice for accounts with current certs of the detected type" do
    student = FactoryBot.create(:student, :quarterfinalist)
    FactoryBot.create(:certificate,
      cert_type: :quarterfinalist,
      account: student.account,
      team: student.team
    )

    expect {
      FillPdfs.(student.account)
    }.not_to change {
      student.certificates.current.quarterfinalist.count
    }
  end

  it "does not generate a certificate for onboarding judges" do
    judge = FactoryBot.create(:judge)

    expect {
      FillPdfs.(judge.account)
    }.not_to change {
      judge.certificates.count
    }
  end
end
