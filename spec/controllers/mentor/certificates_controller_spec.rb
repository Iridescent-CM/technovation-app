require "rails_helper"

RSpec.describe Mentor::CertificatesController, type: :controller do
  describe "POST #create" do
    it "performs the background job for certificates" do
      mentor = FactoryBot.create(:mentor, :on_team, :complete_submission)

      sign_in(mentor)

      expect(CertificateJob).to receive(:perform_later).with(
        mentor.account_id,
        mentor.current_teams.last.id.to_s,
      ).and_call_original

      post :create, params: { team_id: mentor.current_teams.last.id }
    end
  end
end
