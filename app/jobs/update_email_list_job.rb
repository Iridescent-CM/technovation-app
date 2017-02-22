class UpdateEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(email_was, email, name, list_env_key, custom_fields = [])
    return if Rails.env.development? or Rails.env.test?

    email_was = email if email_was.blank?
    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }

    begin
      subscriber = CreateSend::Subscriber.new(auth, ENV.fetch(list_env_key), email_was)
      subscriber.update(email.strip, name, custom_fields, false)
    rescue CreateSend::BadRequest => br
      Rails.logger.info("#{email} - #{br.message}")
    end
  end
end
