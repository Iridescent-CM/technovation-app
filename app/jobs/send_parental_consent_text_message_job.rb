class SendParentalConsentTextMessageJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:)
    account = Account.find(account_id)

    Twilio::ApiClient.new.send_parental_consent_text_message(
      account: account
    )
  end
end
