require "rails_helper"

RSpec.describe Judge::TrainingCompletionsController do
  describe "GET #show" do
    it "records the judge's training completion time" do
      sign_in(:judge)
      get :show
      expect(JudgeProfile.last.completed_training_at).not_to be_nil
    end
  end
end
