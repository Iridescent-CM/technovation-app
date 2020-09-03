require "rails_helper"

RSpec.describe ChapterAmbassador::ParticipantsController do
  describe "GET #index" do
    it "is okay with empty params" do
      chapter_ambassador = FactoryBot.create(:ambassador)
      sign_in(chapter_ambassador)

      expect {
        get :index
      }.not_to raise_error
    end
  end
end
