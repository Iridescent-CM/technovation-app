require "rails_helper"

RSpec.describe Student::CertificatesController, type: :controller do
  describe "POST #create" do
    it "generates a completion cert for the current student" do
      student = FactoryBot.create(:student, :quarterfinalist)

      sign_in(student)

      expect {
        post :create
      }.to change { student.certificates.current.completion.count }.from(0).to(1)
    end
  end
end
