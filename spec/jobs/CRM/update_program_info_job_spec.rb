require "rails_helper"

RSpec.describe CRM::UpdateProgramInfoJob do
  let(:account) { instance_double(Account, id: 9461) }
  let(:profile_type) { "student" }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
  end

  it "calls the DocuSign service that will send the memorandum of understanding" do
    expect(Salesforce::ApiClient).to receive_message_chain(:new, :update_program_info_for)
      .with(account: account, profile_type: profile_type)

    CRM::UpdateProgramInfoJob.perform_now(
      account_id: account.id,
      profile_type: "student"
    )
  end
end
