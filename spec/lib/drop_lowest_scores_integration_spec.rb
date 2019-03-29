require "rails_helper"

RSpec.describe DropLowestScores do
  it "ignores duplicate runs of the same submission" do
    SeasonToggles.set_judging_round(:sf)

    submission = FactoryBot.create(:submission, :complete, number_of_scores: 2)

    expect {
      DropLowestScores.(submission)
    }.to change {
      submission.semifinals_complete_submission_scores.count
    }.from(2).to(1)

    expect(DropLowestScores.(submission)).to be false

    expect {
      DropLowestScores.(submission)
    }.not_to change {
      submission.semifinals_complete_submission_scores.count
    }
  end
end