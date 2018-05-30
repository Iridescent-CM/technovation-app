require "rails_helper"
require "fill_pdfs"

RSpec.describe FillPdfs do
  it "does not run twice for accounts with current certs of the requested type" do
    student = FactoryBot.create(:student, :has_current_completion_certificate)

    recipient = CertificateRecipient.new(student)

    expect {
      FillPdfs.(recipient, :completion)
    }.not_to change {
      student.certificates.current.completion.count
    }
  end
end