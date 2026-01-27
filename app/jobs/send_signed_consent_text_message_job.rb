class SendSignedConsentTextMessageJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, message_type:, delivery_method: :whatsapp)
    account = Account.find(account_id)

    Twilio::ApiClient
      .new(account: account, delivery_method: delivery_method)
      .send_signed_consent_text_message(message_type: message_type)
  end
end
