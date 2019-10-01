class DeleteAccountJob < ActiveJob::Base
  queue_as :default

  def perform(list_scope, email)
    begin
      list = Mailchimp::MailingList.new(list_scope)
      list.delete(email)
    rescue => e
      Rails.logger.error(
        "ERROR UNSUBSCRIBING: #{e.message}"
      )
    end
  end
end
