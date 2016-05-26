require "spec_helper"
require "./app/scores/meaningful_scores"

RSpec.describe "Select meaningful scores" do
  it "is empty for no scores" do
    scores = MeaningfulScores.new([])
    expect(scores).to be_empty
  end

  it "returns <limit> scores for a given limit" do
    allow(MeaningfulScores).to receive(:config) { config }
    collection = [double(:score, provided_feedback_count: 0)] * 2
    scores = MeaningfulScores.new(collection, 1)
    expect(scores.count).to eq(1)
  end

  it "returns a result with a 1-weighted judge comment at the top" do
    empty_comment = double(:empty_comment, provided_feedback_count: 0)
    has_comment = double(:has_comment, provided_feedback_count: 1)
    collection = [empty_comment, has_comment]

    allow(MeaningfulScores).to receive(:config) { config }

    scores = MeaningfulScores.new(collection, 2)

    expect(scores.first).to eq(has_comment)
  end

  it "returns a result with a 2-weighted judge comment over 1-weighted results" do
    one_weighted = double(:one_weighted)
    two_weighted = double(:two_weighted)
    collection = [one_weighted, two_weighted]

    allow(MeaningfulScores).to receive(:config) { config }

    expect(one_weighted).to receive(:provided_feedback_count)
      .with('one_weighted') { 1 }
    expect(one_weighted).to receive(:provided_feedback_count)
      .with('two_weighted') { 0 }

    expect(two_weighted).to receive(:provided_feedback_count)
      .with('one_weighted') { 1 } # doesn't completely matter
    expect(two_weighted).to receive(:provided_feedback_count)
      .with('two_weighted') { 1 }

    scores = MeaningfulScores.new(collection, 2)

    expect(scores.first).to eq(two_weighted)
  end

  it "sorts a heavier weighted score higher" do
    one_weighted = double(:one_weighted)
    also_one_weighted = double(:also_one_weighted)
    two_weighted = double(:two_weighted)
    collection = [one_weighted, also_one_weighted, two_weighted]

    allow(MeaningfulScores).to receive(:config) { config }

    expect(one_weighted).to receive(:provided_feedback_count)
      .with('one_weighted') { 2 }
    expect(one_weighted).to receive(:provided_feedback_count)
      .with('two_weighted') { 0 }

    expect(also_one_weighted).to receive(:provided_feedback_count)
      .with('one_weighted') { 2 }
    expect(also_one_weighted).to receive(:provided_feedback_count)
      .with('two_weighted') { 0 }

    expect(two_weighted).to receive(:provided_feedback_count)
      .with('one_weighted') { 0 }
    expect(two_weighted).to receive(:provided_feedback_count)
      .with('two_weighted') { 1 }

    scores = MeaningfulScores.new(collection, 2)

    expect(scores.first).to eq(two_weighted)
  end

  def config
    {
      "category1" => {
        "weight" => 1,
        "one_weighted" => {}
      },

      "category2" => {
        "weight" => 2,
        "two_weighted" => {}
      }
    }
  end
end
