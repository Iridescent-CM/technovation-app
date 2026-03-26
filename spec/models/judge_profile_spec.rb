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

  describe "#judge_information_completed?" do
    let(:judge) { FactoryBot.create(:judge) }

    it "is incomplete when technical_experience_opt_in is nil" do
      expect(judge.judge_information_completed?).to be false
    end

    it "is complete when technical_experience_opt_in is false" do
      judge.update_column(:technical_experience_opt_in, false)
      expect(judge.judge_information_completed?).to be true
    end

    it "is complete when technical_experience_opt_in is true with technical_skills and ai_experience" do
      judge = FactoryBot.create(:judge, :with_technical_experience_complete)
      expect(judge.judge_information_completed?).to be true
    end
  end

  describe "clearing technical details when technical_experience_opt_in is false" do
    it "clears technical_skills and ai_experience" do
      judge = FactoryBot.create(:judge, :with_technical_experience_complete)
      judge.update(technical_experience_opt_in: false)
      judge.reload

      expect(judge.technical_skills).to be_empty
      expect(judge.ai_experience).to be_nil
    end
  end

  describe "validation" do
    it "requires technical_skills when technical_experience_opt_in is true" do
      judge = FactoryBot.create(:judge, :with_technical_experience_opt_in, :with_ai_experience)
      expect(judge).not_to be_valid
    end

    it "requires ai_experience when technical_experience_opt_in is true" do
      judge = FactoryBot.create(:judge, :with_technical_experience_opt_in, :with_technical_skills)
      expect(judge).not_to be_valid
    end

    it "does not require technical_skills or ai_experience when technical_experience_opt_in is false" do
      judge = FactoryBot.create(:judge)
      judge.update_column(:technical_experience_opt_in, false)
      expect(judge).to be_valid
    end
  end
end
