require "rails_helper"

describe CreateJudgeProfile do
  describe ".call" do
    let(:account) do
      instance_double(
        Account,
        id: 1012,
        can_be_a_judge?: can_be_a_judge,
        is_not_a_judge?: is_not_a_judge,
        chapter_ambassador_profile: chapter_ambassador_profile
      )
    end

    let(:can_be_a_judge) { false }
    let(:is_not_a_judge) { false }
    let(:chapter_ambassador_profile) do
      instance_double(
        ChapterAmbassadorProfile,
        organization_company_name: "Grisha Inc.",
        job_title: "Squaller"
      )
    end

    before do
      allow(account).to receive(:create_judge_profile!)
    end

    context "when an account can be a judge" do
      let(:can_be_a_judge) { true }
      let(:is_not_a_judge) { true }

      it "calls AddProfileTypeToAccountOnEmailListJob - adding the profile type 'judge' to the account" do
        expect(AddProfileTypeToAccountOnEmailListJob).to receive(:perform_later)
          .with(account_id: account.id, profile_type: "judge")

        CreateJudgeProfile.call(account)
      end
    end

    context "when an account cannot be a judge" do
      let(:can_be_a_judge) { false }
      let(:is_not_a_judge) { false }

      it "does not call AddProfileTypeToAccountOnEmailListJob" do
        expect(AddProfileTypeToAccountOnEmailListJob).not_to receive(:perform_later)
          .with(account_id: account.id, profile_type: "judge")

        CreateJudgeProfile.call(account)
      end
    end
  end
end
