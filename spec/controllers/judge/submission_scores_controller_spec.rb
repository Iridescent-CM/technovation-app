require "rails_helper"

RSpec.describe Judge::SubmissionScoresController, vcr: { record: :all }, no_es_stub: true do
  describe "GET #new" do
    it "sets up a score as opened by the judge at current time" do
      team = FactoryGirl.create(:team)
      submission = TeamSubmission.create!(
        integrity_affirmed: true,
        team: team
      )

      now = Time.current
      judge = FactoryGirl.create(:judge)

      JudgeProfile.__elasticsearch__.create_index! force:true
      TeamSubmission.__elasticsearch__.create_index! force:true
      judge.__elasticsearch__.index_document refresh: true
      submission.__elasticsearch__.index_document refresh: true

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

      expect(judge.submission_scores.last.team_submission.submission_scores_count).to eq(1)
    end
  end
end
