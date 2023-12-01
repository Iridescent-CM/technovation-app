require "rails_helper"

RSpec.describe SubscribeAccountToEmailListJob do
  let(:account) { double(Account, id: 1, email: "beth@example.com") }
  let(:profile_type) { "student" }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
    allow(Mailchimp::MailingList).to receive_message_chain(:new, :subscribe)
    allow(Salesforce::ApiClient).to receive_message_chain(:new, :add_contact)
  end

  it "calls the Mailchimp service that will subscribe the account" do
    expect(Mailchimp::MailingList).to receive_message_chain(:new, :subscribe)
      .with(account: account, profile_type: profile_type)

    SubscribeAccountToEmailListJob.perform_now(account_id: account.id, profile_type: profile_type)
  end

  it "calls the Salesforce service that will subscribe the account" do
    expect(Salesforce::ApiClient).to receive_message_chain(:new, :add_contact)
      .with(account: account)

    SubscribeAccountToEmailListJob.perform_now(account_id: account.id, profile_type: profile_type)
  end
end
