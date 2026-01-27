class SendParentalConsentTextMessageJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, delivery_method: :whatsapp)
    account = Account.find(account_id)

    Twilio::ApiClient
      .new(account: account, delivery_method: delivery_method)
      .send_parental_consent_text_message
  end
end
