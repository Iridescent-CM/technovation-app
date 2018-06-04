require "rails_helper"
require "fill_pdfs"

RSpec.describe FillPdfs do
  it "does not run twice for accounts with current certs of the detected type" do
    student = FactoryBot.create(:student, :quarterfinalist, :has_current_completion_certificate)

    expect {
      FillPdfs.(student)
    }.not_to change {
      student.certificates.current.completion.count
    }
  end
end