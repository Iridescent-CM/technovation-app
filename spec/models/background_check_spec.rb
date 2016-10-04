require "rails_helper"

RSpec.describe BackgroundCheck do
  describe "#clear!" do
    it "emails the mentor or RA" do
      account = FactoryGirl.create(%i{mentor regional_ambassador}.sample)

      account.background_check.pending!
      account.background_check.clear!

      email = ActionMailer::Base.deliveries.last
      expect(email).to be_present, "no account email sent"
      expect(email.to).to eq([account.email])
    end
  end
end
