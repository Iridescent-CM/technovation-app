class DeleteAccountFromEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(email_address:)
    Mailchimp::MailingList.new.delete(email_address: email_address)
  end
end
