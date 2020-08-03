require "rails_helper"

RSpec.describe BackgroundCheck do
  describe "#clear!" do
    %i{mentor chapter_ambassador}.each do |scope|
      it "emails the #{scope}" do
        account = FactoryBot.create(scope, :geocoded)

        account.background_check.pending!

        BackgroundChecking.new(
          account.background_check,
          report: FakeReport.new
        ).execute

        email = ActionMailer::Base.deliveries.last
        expect(email).to be_present, "no account email sent"
        expect(email.to).to eq([account.email])
      end
    end
  end
end
