require "rails_helper"

RSpec.describe "Resetting consents" do
  let!(:consent_waiver) { FactoryBot.create(:consent_waiver) }

  it "does nothing on days other than switch date" do
    Timecop.freeze(Time.new(2009, Season::START_MONTH - 1, 28)) do
      Rake::Task["reset_consents"].execute
      expect(consent_waiver.reload).not_to be_voided
    end
  end

  it "voids all nonvoid consents on switch date" do
    Timecop.freeze(Time.new(2009, Season::START_MONTH, Season::START_DAY)) do
      Rake::Task["reset_consents"].execute
      expect(consent_waiver.reload).to be_voided
    end
  end
end
