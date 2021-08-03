require "rails_helper"

RSpec.describe Public::EmailValidationsController do
  describe "GET #new" do
    context "when the email is taken" do
      let(:email) { URI::DEFAULT_PARSER.escape("taKen@taken.com ") }
      let(:json) { JSON.parse(response.body)["data"]["attributes"] }

      before do
        FactoryBot.create(:account, email: " tAken@taken.com")
        get "/public/email_validations/new?address=#{email}"
      end

      it "renders the email is_valid" do
        expect(json["is_valid"]).to be(true)
      end

      it "renders the mailbox_verification is 'true'" do
        expect(json["mailbox_verification"]).to be(true)
      end

      it "renders the email is_taken" do
        expect(json["is_taken"]).to be(true)
      end
    end

    context "when the email is new", vcr: {record: :new_episodes} do
      context "and it is valid" do
        let(:email) { URI::DEFAULT_PARSER.escape("joe@joesak.com") }
        let(:json) { JSON.parse(response.body)["data"]["attributes"] }

        before do
          get "/public/email_validations/new?address=#{email}"
        end

        it "renders the email is_valid" do
          expect(json["is_valid"]).to be(true)
        end

        it "renders the mailbox_verification is true" do
          expect(json["mailbox_verification"]).to be(true)
        end

        it "renders the email not is_taken" do
          expect(json["is_taken"]).to be(nil)
        end
      end

      context "and it is a @qq.com email" do
        let(:email) { URI::DEFAULT_PARSER.escape("3409186790@qq.com") }
        let(:json) { JSON.parse(response.body)["data"]["attributes"] }

        before do
          get "/public/email_validations/new?address=#{email}"
        end

        it "always returns valid" do
          expect(json["is_valid"]).to be(true)
        end
      end

      context "and it is a @alumno.fomento.edu email" do
        let(:email) { URI::DEFAULT_PARSER.escape("yourname@alumno.fomento.edu") }
        let(:json) { JSON.parse(response.body)["data"]["attributes"] }

        before do
          get "/public/email_validations/new?address=#{email}"
        end

        it "always returns valid" do
          expect(json["is_valid"]).to be(true)
        end
      end
    end
  end
end
