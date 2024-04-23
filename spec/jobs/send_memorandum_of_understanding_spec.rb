require "rails_helper"

RSpec.describe SendMemorandumOfUnderstandingJob do
  let(:full_name) { "Lacey Taro" }
  let(:email_address) { "laceyt@example.com" }
  let(:organization_name) { "Blueberry Academy" }
  let(:job_title) { "Pokémon Trainer" }

  it "calls the DocuSign service that will send the memorandum of understanding" do
    expect(Docusign::ApiClient).to receive_message_chain(:new, :send_memorandum_of_understanding)
      .with(
        full_name: full_name,
        email_address: email_address,
        organization_name: organization_name,
        job_title: job_title
      )

    SendMemorandumOfUnderstandingJob.perform_now(
      full_name: full_name,
      email_address: email_address,
      organization_name: organization_name,
      job_title: job_title
    )
  end
end
