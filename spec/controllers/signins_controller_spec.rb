require "rails_helper"

RSpec.describe SigninsController do
  describe "POST #create" do
    it "is case-insenstive for email" do
      FactoryGirl.create(:student, email: "CapiTalLettERS@gmail.com")

      post :create, account: { email: "capitalletters@gmail.com", password: "secret1234" }
      expect(response).to redirect_to(student_dashboard_path)
    end
  end
end
