require "rails_helper"

RSpec.describe DeleteAccountFromEmailListJob do
  let(:email_address) { "beth@example.com" }

  it "calls the Mailchimp service that will scrub the account from the email list" do
    expect(Mailchimp::MailingList).to receive_message_chain(:new, :delete).
      with(email_address: email_address)

    DeleteAccountFromEmailListJob.perform_now(email_address: email_address)
  end
end
