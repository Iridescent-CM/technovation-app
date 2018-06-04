require "rails_helper"

RSpec.describe Mentor::CertificatesController, type: :controller do
  describe "POST #create" do
    it "generates a completion cert for the current mentor" do
      mentor = FactoryBot.create(:mentor, :on_team, :complete_submission)

      sign_in(mentor)

      expect {
        post :create
      }.to change {
         mentor.certificates.completion.count
      }.from(0).to(1)
    end
  end
end
