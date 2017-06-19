require "rails_helper"
require "rake"
Rails.application.load_tasks

RSpec.describe "Resetting parental consents" do
  let!(:parental_consent) { FactoryGirl.create(:parental_consent) }

  it "does nothing on days other than Aug 1" do
    Timecop.freeze(Time.new(2009, 7, 31)) do
      Rake::Task["reset_parental_consents"].execute
      expect(parental_consent.reload).not_to be_voided
    end
  end

  it "voids all nonvoid parental consents on Aug 1" do
    Timecop.freeze(Time.new(2009, 8, 1)) do
      Rake::Task["reset_parental_consents"].execute
      expect(parental_consent.reload).to be_voided
    end
  end
end
