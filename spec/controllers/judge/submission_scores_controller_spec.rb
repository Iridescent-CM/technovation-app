require "rails_helper"

RSpec.describe Judge::SubmissionScoresController do
  describe "GET #new" do
    it "sets up a score as opened by the judge at current time" do
      team = FactoryGirl.create(:team)
      FactoryGirl.create(:submission, :complete, team: team)

      now = Time.current
      judge = FactoryGirl.create(:judge)

      sign_in(judge)

      Timecop.freeze(now) { get :new }

      expect(judge.submission_scores.last.team_submission.judge_opened_id).to eq(judge.id)

      expect(
        judge
        .submission_scores
        .last
        .team_submission
        .judge_opened_at
        .strftime("%Y%m%d%H%M%S")
      ).to eq(now.strftime("%Y%m%d%H%M%S"))

      submission = judge.submission_scores.last.team_submission
      expect(submission.submission_scores_count).to eq(1)
    end
  end
end
