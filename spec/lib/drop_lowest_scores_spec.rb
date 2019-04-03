require "spec_helper"
require "./lib/drop_lowest_scores"
require "./app/null_objects/null_profile"

RSpec.describe DropLowestScores do
  it "deletes the lowest score " do
    lowest_score = double(
      :Score,
      total: 45,
      destroy: true,
      save: true,
      :drop_score! => true,
      judge_profile: NullProfile.new
    )

    scores = [
      double(:Score, total: 100),
      lowest_score,
    ]

    submission = double(
      :Submission,
      id: 1,
      team_id: 2,
      semifinals_complete_submission_scores: scores,
      :lowest_score_dropped? => false,
      :lowest_score_dropped! => true,
      semifinals_average_score: 64.209,
    )

    allow(submission).to receive(:reload).and_return(submission)

    expect(lowest_score).to receive(:destroy)
    DropLowestScores.(submission)
  end

  it "ignores submissions which already dropped their lowest score" do
    submission = double(:Submission, id: 1, :lowest_score_dropped? => true)
    expect(DropLowestScores.(submission)).to be false
  end
end