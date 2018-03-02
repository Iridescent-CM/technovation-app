class DeleteAccountJob < ActiveJob::Base
  queue_as :default

  def perform(list_id, email)
    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }

    begin
      CreateSend::Subscriber.new(
        auth,
        ENV.fetch(list_id),
        email
      ).delete
    rescue => e
      Rails.logger.error(
        "ERROR UNSUBSCRIBING: #{e.message}"
      )
    end
  end
end
