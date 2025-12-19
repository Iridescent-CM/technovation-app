require "rails_helper"

RSpec.describe SendParentalConsentTextMessageJob do
  let(:account) {instance_double(Account, id: 123)}

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
  end

  it "calls the Twilio service that will send the parental consent text message" do
    expect(Twilio::ApiClient).to receive_message_chain(:new, :send_parental_consent_text_message)
      .with(account: account)

    SendParentalConsentTextMessageJob.perform_now(account_id: account.id)
  end
end
