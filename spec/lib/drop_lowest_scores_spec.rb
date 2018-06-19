require "spec_helper"
require "./lib/drop_lowest_scores"
require "./app/null_objects/null_profile"

RSpec.describe DropLowestScores do
  it "deletes the lowest score " do
    lowest_score = double(:Score, total: 45, destroy: true, judge_profile: NullProfile.new)

    scores = [
      double(:Score, total: 100),
      lowest_score,
    ]

    submission = double(
      :Submission,
      id: 1,
      semifinals_complete_submission_scores: scores
    )

    expect(lowest_score).to receive(:destroy)
    DropLowestScores.(submission)
  end
end