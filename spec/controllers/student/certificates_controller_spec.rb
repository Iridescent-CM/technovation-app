require "rails_helper"

RSpec.describe Student::CertificatesController, type: :controller do
  describe "POST #create" do
    it "generates a completion cert for the current student" do
      student = FactoryBot.create(:student)

      sign_in(student)

      expect {
        post :create, params: { type: :completion }
      }.to change { student.certificates.current.completion }.from(0).to(1)
    end

    it "generates an rpe winner cert for the current student" do
      student = FactoryBot.create(:student)

      sign_in(student)

      expect {
        post :create, params: { type: :rpe_winner }
      }.to change { student.certificates.current.rpe_winner }.from(0).to(1)
    end
  end
end
