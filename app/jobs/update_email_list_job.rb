class UpdateEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(email_was, email, name, list_id)
    return if Rails.env.development? or Rails.env.test?

    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }
    subscriber = CreateSend::Subscriber.new(auth, list_id, email_was)

    subscriber.update(email, name, [], true)
  end
end
