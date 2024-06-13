require "rails_helper"

RSpec.describe ChapterAmbassador::TrainingCompletionsController do
  describe "GET #show" do
    it "records the chapter ambassador's training completion time" do
      sign_in(:chapter_ambassador)
      get :show
      expect(ChapterAmbassadorProfile.last.training_completed_at).not_to be_nil
    end
  end
end
