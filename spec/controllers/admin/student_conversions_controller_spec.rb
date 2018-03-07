require "rails_helper"

RSpec.describe Admin::StudentConversionsController do
  describe "POST #create" do
    it "deletes the student profile" do
      student = FactoryBot.create(:student)

      sign_in(:admin)
      post :create, params: { student_profile_id: student.id }

      expect {
        student.reload
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not delete the account" do
      student = FactoryBot.create(:student)
      account = student.account

      sign_in(:admin)
      post :create, params: { student_profile_id: student.id }

      expect(account.reload).to be_present
    end

    it "adds a mentor profile to the account" do
      student = FactoryBot.create(:student)
      account = student.account

      sign_in(:admin)
      post :create, params: { student_profile_id: student.id }

      expect(account.reload.mentor_profile).to be_present
    end
  end
end
