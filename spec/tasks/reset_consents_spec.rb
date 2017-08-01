require "rails_helper"

RSpec.describe "Resetting consents" do
  let!(:parental_consent) { FactoryGirl.create(:parental_consent) }
  let!(:consent_waiver) { FactoryGirl.create(:consent_waiver) }

  it "does nothing on days other than switch date" do
    Timecop.freeze(Time.new(2009, Season.switch_month - 1, 28)) do
      Rake::Task["reset_consents"].execute
      expect(parental_consent.reload).not_to be_voided
      expect(consent_waiver.reload).not_to be_voided
    end
  end

  it "voids all nonvoid consents on switch date" do
    Timecop.freeze(Time.new(2009, Season.switch_month, Season.switch_day)) do
      Rake::Task["reset_consents"].execute
      expect(parental_consent.reload).to be_voided
      expect(consent_waiver.reload).to be_voided
    end
  end
end
