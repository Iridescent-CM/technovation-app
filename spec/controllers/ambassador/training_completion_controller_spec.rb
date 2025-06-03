require "rails_helper"

RSpec.describe Ambassador::TrainingCompletionController do
  describe "GET #show" do
    it "records the chapter ambassador's training completion time" do
      sign_in(:chapter_ambassador)
      get :show
      expect(ChapterAmbassadorProfile.last.training_completed_at).not_to be_nil
    end

    it "records the club ambassador's training completion time" do
      sign_in(:club_ambassador)
      get :show
      expect(ClubAmbassadorProfile.last.training_completed_at).not_to be_nil
    end
  end
end
