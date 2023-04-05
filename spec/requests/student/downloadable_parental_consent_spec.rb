require "rails_helper"

RSpec.describe Student::DownloadableParentalConsentsController do
  let(:student_account) { FactoryBot.create(:account, email: student_email_address) }
  let(:student_email_address) { "harry@example.com"  }
  let(:student_profile) {
    FactoryBot.create(:student_profile, :geocoded,
      account: student_account,
      parent_guardian_name: parent_guardian_name,
      parent_guardian_email: parent_guardian_email_address)
  }

  describe "GET #show" do
    before do
      sign_in student_profile
      get student_downloadable_parental_consent_path(format: :pdf)

      expect(response.content_type).to eq("application/pdf")

      io = StringIO.new(response.body)
      reader = PDF::Reader.new(io)
      @pdf_text = reader.pages.collect { |page| page.text }.join(" ").squish
    end

    after(:each) do |example|
      if example.exception
        puts response.body
      end
    end

    context "when no parent data has been provided" do
      let(:parent_guardian_name) { nil }
      let(:parent_guardian_email_address) { nil }

      it "pre-fills student data" do
        expect(@pdf_text).to include(student_account.name)
        expect(@pdf_text).to include(student_email_address)
      end
    end

    context "when parent data has been provided" do
      let(:parent_guardian_name) { "Parent Name" }
      let(:parent_guardian_email_address) { "parent@example.com" }

      it "pre-fills parent data as well" do
        expect(@pdf_text).to include(parent_guardian_name)
      end
    end
  end
end
