require "rails_helper"

class FakeReport
  def status; 'clear'; end
  def adjudication; ''; end
end

RSpec.describe BackgroundCheck do
  describe "#clear!" do
    it "emails the mentor or RA" do
      account = FactoryGirl.create(%i{mentor regional_ambassador}.sample)

      account.background_check.pending!
      BackgroundChecking.new(account.background_check, FakeReport.new()).execute()

      email = ActionMailer::Base.deliveries.last
      expect(email).to be_present, "no account email sent"
      expect(email.to).to eq([account.email])
    end
  end
end
