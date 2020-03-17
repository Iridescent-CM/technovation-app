require "rails_helper"

RSpec.describe JudgeProfile do
  describe "#suspend!" do
    it "suspends the judge" do
      judge = FactoryBot.create(:judge)

      expect(JudgeProfile.suspended).not_to include(judge)
      judge.suspend!
      expect(JudgeProfile.suspended).to include(judge)
    end

    it "raises on a failed update" do
      judge = FactoryBot.create(:judge)
      judge.update_column(:company_name, '')
      expect {
        judge.suspend!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#unsuspend!" do
    it "unsuspends the judge" do
      judge = FactoryBot.create(:judge, suspended: true)

      expect(JudgeProfile.suspended).to include(judge)
      judge.unsuspend!
      expect(JudgeProfile.suspended).not_to include(judge)
    end

    it "raises on a failed update" do
      judge = FactoryBot.create(:judge)
      judge.update_column(:company_name, '')
      expect {
        judge.unsuspend!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end