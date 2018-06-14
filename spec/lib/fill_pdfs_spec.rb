require "rails_helper"
require "fill_pdfs"

RSpec.describe FillPdfs do
  it "does not run twice for accounts with current certs of the detected type" do
    student = FactoryBot.create(:student, :quarterfinalist, :has_current_completion_certificate)

    expect {
      FillPdfs.(student.account, student.team)
    }.not_to change {
      student.certificates.current.completion.count
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