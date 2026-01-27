require "rails_helper"

RSpec.describe SendParentalConsentTextMessageJob do
  let(:account) { instance_double(Account, id: 123) }
  let(:api_client) { instance_double(Twilio::ApiClient) }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
  end

  it "calls the Twilio service that will send the parental consent text message" do
    expect(Twilio::ApiClient).to receive(:new)
      .with(account: account, delivery_method: :whatsapp)
      .and_return(api_client)

    expect(api_client).to receive(:send_parental_consent_text_message)

    SendParentalConsentTextMessageJob.perform_now(account_id: account.id, delivery_method: :whatsapp)
  end
end
