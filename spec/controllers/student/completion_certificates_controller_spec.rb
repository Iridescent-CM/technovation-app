require "rails_helper"

RSpec.describe Student::CompletionCertificatesController, type: :controller do
  describe "POST #create" do
    it "generates a completion cert for the current student" do
      student = FactoryGirl.create(:student)

      sign_in(student)

      expect(student.certificates).to be_empty

      post :create

      expect(student.certificates).not_to be_empty
    end
  end
end
