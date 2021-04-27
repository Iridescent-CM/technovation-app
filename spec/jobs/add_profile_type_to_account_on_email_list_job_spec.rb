require "rails_helper"

RSpec.describe AddProfileTypeToAccountOnEmailListJob do
  let(:account) { double(Account, id: 1, email: "alina@example.com") }
  let(:profile_type_to_add) { "student" }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
  end

  it "calls the Mailchimp service that will add the profile type to the account" do
    expect(Mailchimp::MailingList).to receive_message_chain(:new, :add_profile_type_to_account)
      .with(profile_type: profile_type_to_add, account: account)

    AddProfileTypeToAccountOnEmailListJob.perform_now(
      profile_type: profile_type_to_add,
      account_id: account.id
    )
  end
end
