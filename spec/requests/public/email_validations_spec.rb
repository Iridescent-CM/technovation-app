require "rails_helper"

RSpec.describe Public::EmailValidationsController do
  describe "GET #new" do
    context "when the email is taken" do
      let(:email) { URI.encode('taKen@taken.com ') }
      let(:json) { JSON.parse(response.body)['data']['attributes'] }

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
        expect(json['is_taken']).to be(true)
      end
    end

    context "when the email is new", vcr: { record: :new_episodes } do
      context "and it is valid" do
        let(:email) { URI.encode('joe@joesak.com') }
        let(:json) { JSON.parse(response.body)['data']['attributes'] }

        before do
          get "/public/email_validations/new?address=#{email}"
        end

        it "renders the email is_valid" do
          expect(json['is_valid']).to be(true)
        end

        it "renders the mailbox_verification is true" do
          expect(json['mailbox_verification']).to be(true)
        end

        it "renders the email not is_taken" do
          expect(json['is_taken']).to be(nil)
        end

        it "creates a wizarding signup attempt" do
          attempt = SignupAttempt.find_by!(email: email)
          expect(attempt).to be_wizard
        end

        it "sets the signup attempt signup token in cookies" do
          attempt = SignupAttempt.find_by!(email: email)
          expect(controller.get_cookie(CookieNames::SIGNUP_TOKEN)).to eq(attempt.wizard_token)
        end
      end

      context "and it matches an existing signup attempt" do
        it "sets the signup attempt signup token in cookies" do
          email = "existing@attempt.com"
          encoded = URI.encode(email)

          SignupAttempt.create!(email: email, status: :wizard)

          expect {
            get "/public/email_validations/new?address=#{encoded}"
          }.not_to change {
            SignupAttempt.count
          }

          attempt = SignupAttempt.find_by!(email: email)
          expect(controller.get_cookie(CookieNames::SIGNUP_TOKEN)).to eq(attempt.wizard_token)
        end
      end
    end
  end
end