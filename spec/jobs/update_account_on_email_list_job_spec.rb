require "rails_helper"

RSpec.describe UpdateAccountOnEmailListJob do
  let(:account) { double(Account, id: 1, email: "beth@example.com") }
  let(:currently_subscribed_as) { account.email }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
    allow(Mailchimp::MailingList).to receive_message_chain(:new, :update)
    allow(Salesforce::ApiClient).to receive_message_chain(:new, :update_contact)
  end

  it "calls the Mailchimp service that will update the account for the provided email address" do
    expect(Mailchimp::MailingList).to receive_message_chain(:new, :update)
      .with(currently_subscribed_as: currently_subscribed_as, account: account)

    UpdateAccountOnEmailListJob.perform_now(
      account_id: account.id,
      currently_subscribed_as: currently_subscribed_as
    )
  end

  it "calls the Salesforce service that will update the account" do
    expect(Salesforce::ApiClient).to receive_message_chain(:new, :update_contact)
      .with(account: account)

    UpdateAccountOnEmailListJob.perform_now(
      account_id: account.id,
      currently_subscribed_as: currently_subscribed_as
    )
  end
end
