require "rails_helper"

RSpec.describe RefreshDocusignAccessTokenJob do
  it "calls the DocuSign service that will refresh the access token" do
    expect(Docusign::Authentication).to receive_message_chain(:new, :refresh_access_token)

    RefreshDocusignAccessTokenJob.perform_now
  end
end
