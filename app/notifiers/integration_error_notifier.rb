class IntegrationErrorNotifier < Noticed::Event
  bulk_deliver_by :slack do |config|
    config.url = ENV.fetch("SLACK_URL_FOR_INTEGRATION_ERROR_NOTIFIER")
    config.json = -> {
      {
        text: params[:error_message]
      }
    }
    config.if = -> {
      Rails.env.production? &&
        ENV.fetch("SLACK_URL_FOR_INTEGRATION_ERROR_NOTIFIER").present?
    }
  end
end
