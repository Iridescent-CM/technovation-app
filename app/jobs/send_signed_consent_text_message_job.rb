class SendSignedConsentTextMessageJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, consent_type:)
    account = Account.find(account_id)
    Twilio::ApiClient.new.send_signed_consent_text_message(
      account: account,
      consent_type: consent_type
    )
  end
end
