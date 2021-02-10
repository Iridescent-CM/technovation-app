require "rails_helper"

RSpec.describe Admin::StudentConversionsController do
  describe "POST #create" do
    let(:student_profile) { FactoryBot.create(:student, date_of_birth: 18.years.ago) }
    let(:account) { student_profile.account }

    before do
      sign_in(:admin)

      post :create, params: { student_profile_id: student_profile.id }
      account.reload
    end

    it "adds a mentor profile to the account" do
      expect(account.mentor_profile).to be_present
    end

    it "deletes the student profile on the account" do
      expect(account.student_profile).to be_nil
    end

    it "does not delete the account" do
      expect(account).to be_present
    end
  end
end
