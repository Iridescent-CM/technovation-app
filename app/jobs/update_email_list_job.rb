class UpdateEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(email_was, email, list_scope, merge_fields = {})
    email_was = email if email_was.blank?

    begin
      list = Mailchimp::MailingList.new(list_scope)
      list.update(email_was, email, merge_fields)
    rescue Mailchimp::APIRequestError => e
      Rails.logger.error("[UPDATE EMAIL LIST ERROR] #{email} - #{e.message}")
    end
  end
end
