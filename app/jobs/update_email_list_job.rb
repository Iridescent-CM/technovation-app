class UpdateEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(email_was, email, name, list_env_key, custom_fields = [])
    return if Rails.env.development? or Rails.env.test?

    email_was = email if email_was.blank?
    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }

    begin
      subscriber = CreateSend::Subscriber.new(auth, ENV.fetch(list_env_key), email_was)
      subscriber.update(email.strip, name, custom_fields, true)
    rescue CreateSend::BadRequest => br
      if br.message.include?("Subscriber not in list") or
           br.message.include?("provide a valid email address") or
             email_was.nil?
        SubscribeEmailListJob.perform_later(email.strip, name, list_env_key, custom_fields)
      else
        raise br
      end
    end
  end
end
