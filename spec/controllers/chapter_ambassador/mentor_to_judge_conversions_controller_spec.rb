require "rails_helper"

RSpec.describe ChapterAmbassador::MentorToJudgeConversionsController do
  describe "POST #create" do
    let!(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :approved) }
    let!(:mentor) { FactoryBot.create(:mentor, :onboarded) }

    before do
      sign_in(chapter_ambassador)
      allow(CRM::SetupAccountForCurrentSeasonJob).to receive(:perform_later)
    end

    it "creates a judge profile and deletes the mentor profile" do
      expect {
        post :create, params: { account_id: mentor.account_id }
      }.to change { JudgeProfile.count }.by(1)
        .and change { MentorProfile.count }.by(-1)

      account = mentor.account.reload
      expect(response).to redirect_to(chapter_ambassador_participant_path(account))
      expect(account.judge_profile).to be_present
      expect(account.mentor_profile).to be_nil
      expect(account.judge_profile.company_name).to eq(mentor.school_company_name)
      expect(account.judge_profile.job_title).to eq(mentor.job_title)
    end

    it "does not error when mentor profile mentor types trigger CRM callbacks on destroy" do
      expect(CRM::UpsertProgramInfoJob).to receive(:perform_later).at_least(:once)

      expect {
        post :create, params: { account_id: mentor.account_id }
      }.not_to raise_error
    end

    it "sets up the judge profile in the CRM" do
      expect(CRM::SetupAccountForCurrentSeasonJob).to receive(:perform_later).with(
        account_id: mentor.account_id,
        profile_type: "judge"
      )

      post :create, params: { account_id: mentor.account_id }
    end

    context "when the account already has a judge profile" do
      let!(:mentor) { FactoryBot.create(:mentor, :onboarded, :has_judge_profile) }

      it "does not create another judge profile" do
        expect {
          post :create, params: { account_id: mentor.account_id }
        }.not_to change { JudgeProfile.count }
      end
    end
  end
end
