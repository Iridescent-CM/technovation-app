require "spec_helper"
require "./lib/drop_lowest_scores"

RSpec.describe DropLowestScores do
  Array(1..4).each do |n|
    it "deletes nothing if there are #{n} or less scores" do
      scores = [double(:Score, total: rand(80))] * n
      submission = double(
        :Submission,
        id: 1,
        semifinals_complete_submission_scores: scores
      )

      scores.each do |score|
        expect(score).not_to receive(:destroy)
      end

      DropLowestScores.(submission)
    end
  end

  it "deletes the lowest score for 5 or more scores" do
    lowest_score = double(:Score, total: 45, destroy: true)

    scores = [
      double(:Score, total: 100),
      double(:Score, total: 95),
      lowest_score,
      double(:Score, total: 85),
      double(:Score, total: 75),
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