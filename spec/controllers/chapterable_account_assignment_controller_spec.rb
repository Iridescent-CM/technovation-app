require "rails_helper"

RSpec.describe ChapterableAccountAssignmentsController do
  describe "POST #unset_force_chapterable_selection" do
    let(:student_profile) { FactoryBot.create(:student) }

    before do
      student_profile.account.update(force_chapterable_selection: true)

      sign_in(student_profile)
    end

    it "unsets the `force_chapterable_selection` flag" do
      post :unset_force_chapterable_selection

      expect(student_profile.account.reload.force_chapterable_selection).to eq(false)
    end
  end
end
