require "rails_helper"

RSpec.describe Student::CertificatesController, type: :controller do
  describe "POST #create" do
    it "generates a completion cert for the current student" do
      student = FactoryGirl.create(:student)

      sign_in(student)

      expect(student.certificates.completion).to be_empty

      post :create, params: { type: :completion }

      expect(student.certificates.completion).not_to be_empty
    end

    it "generates an rpe winner cert for the current student" do
      student = FactoryGirl.create(:student)

      sign_in(student)

      expect(student.certificates.rpe_winner).to be_empty

      post :create, params: { type: :rpe_winner }

      expect(student.certificates.rpe_winner).not_to be_empty
    end
  end
end
