require "rails_helper"

RSpec.describe Public::EmailValidationsController do
  describe "GET #new" do
    context "when the email is taken" do
      let(:email) { URI.encode('taKen@taken.com ') }
      let(:json) { JSON.parse(response.body) }

      before do
        FactoryBot.create(:account, email: " tAken@taken.com")
        get "/public/email_validations/new?address=#{email}"
      end

      it "renders the email is_valid" do
        expect(json['is_valid']).to be(true)
      end

      it "renders the mailbox_verification is 'true'" do
        expect(json['mailbox_verification']).to be(true)
      end

      it "renders the email is_taken" do
        expect(json['is_taken']).to eq(true)
      end
    end
  end
end