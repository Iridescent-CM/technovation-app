class SubscribeEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(email, name, list_env_key)
    return if Rails.env.development? or Rails.env.test?

    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }

    begin
      CreateSend::Subscriber.add(auth, ENV.fetch(list_env_key), email, name, [], true)
    rescue CreateSend::BadRequest => br
      p "Error: #{br}"
    end
  end
end
