require "rails_helper"

RSpec.describe Mentor::DashboardsController do
  describe "POST #unset_force_chapterable_selection" do
    let(:mentor_profile) { FactoryBot.create(:mentor) }

    before do
      mentor_profile.account.update(force_chapterable_selection: true)

      sign_in(mentor_profile)
    end

    it "unsets the `force_chapterable_selection` flag" do
      post :unset_force_chapterable_selection

      expect(mentor_profile.account.reload.force_chapterable_selection).to eq(false)
    end
  end
end
