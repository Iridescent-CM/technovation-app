require "rails_helper"

RSpec.describe Admin::StudentConversionsController do
  describe "POST #create" do
    let(:student) { FactoryBot.create(:student, date_of_birth: 18.years.ago) }
    let(:account) { student.account }

    before { sign_in(:admin) }
    it "preserves the student profile for historical purposes" do
      post :create, params: { student_profile_id: student.id }

      expect {
        student.reload
      }.not_to raise_error
    end

    it "does not delete the account" do
      post :create, params: { student_profile_id: student.id }
      expect(account.reload).to be_present
    end

    it "adds a mentor profile to the account" do
      post :create, params: { student_profile_id: student.id }
      expect(account.reload.mentor_profile).to be_present
    end
  end
end
