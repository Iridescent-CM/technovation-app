require "rails_helper"

RSpec.describe BackgroundCheck do
  describe "#clear!" do
    %i[mentor chapter_ambassador].each do |scope|
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

  context "callbacks" do
    let(:background_check) { FactoryBot.create(:background_check, account: chapter_ambassador.account) }
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

    context "#after_update" do
      it "makes a call to update the chapter ambassador's onboarding status when the background check is updated" do
        expect(chapter_ambassador).to receive(:update_onboarding_status)

        background_check.update(status: "clear")
      end
    end
  end
end
