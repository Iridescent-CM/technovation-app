require "rails_helper"

RSpec.describe Mentor::CertificatesController, type: :controller do
  describe "POST #create" do
    it "generates an appreciation cert for the current mentor" do
      mentor = FactoryGirl.create(:mentor)

      sign_in(mentor)

      expect(mentor.certificates.appreciation).to be_empty

      post :create, params: { type: :appreciation }

      expect(mentor.certificates.appreciation).not_to be_empty
    end
  end
end
