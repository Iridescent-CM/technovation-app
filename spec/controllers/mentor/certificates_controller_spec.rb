require "rails_helper"

RSpec.describe Mentor::CertificatesController, type: :controller do
  describe "POST #create" do
    it "performs the background job for certificates" do
      mentor = FactoryBot.create(:mentor, :on_team, :complete_submission)

      sign_in(mentor)

      expect(CertificateJob).to receive(:perform_later).with(
        mentor.account_id,
        mentor.current_teams.last.id,
      ).and_call_original

      post :create
    end
  end

  it "renders JSON with the job ID"
end
