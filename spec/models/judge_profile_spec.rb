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
      judge.update_column(:company_name, "")
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
      judge.update_column(:company_name, "")
      expect {
        judge.unsuspend!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "callbacks" do
    let(:judge) { FactoryBot.create(:judge) }

    describe "#after_add event" do
      it "makes a call to upsert the judge info in the CRM after an event is added to the judge " do
        expect(CRM::UpsertProgramInfoJob).to receive(:perform_later).with(account_id: judge.account_id, profile_type: "judge")

        judge.events << FactoryBot.create(:event)
      end
    end

    describe "#after_remove event" do
      before do
        judge.events << FactoryBot.create(:event)
      end

      it "makes a call to upsert the judge info in the CRM after an event is removed from the judge " do
        expect(CRM::UpsertProgramInfoJob).to receive(:perform_later).with(account_id: judge.account_id, profile_type: "judge")

        judge.events.destroy_all
      end
    end
  end
end
