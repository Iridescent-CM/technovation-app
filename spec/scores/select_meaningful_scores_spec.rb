require "spec_helper"
require "./app/models/meaningful_scores"

RSpec.describe "Select meaningful scores" do
  it "is empty for no scores" do
    scores = MeaningfulScores.new([])
    expect(scores).to be_empty
  end

  it "returns <limit> scores for a given limit" do
    collection = [double.as_null_object] * 2
    scores = MeaningfulScores.new(collection, 1)
    expect(scores.count).to eq(1)
  end

  it "returns a result with a 1-weighted judge comment at the top" do
    empty_comment = double(:empty_comment, id: 0, field_comment: "")
    has_comment = double(:has_comment, id: 1, field_comment: "content exists")
    collection = [empty_comment, has_comment]

    allow(MeaningfulScores).to receive(:config) { basic_config }

    scores = MeaningfulScores.new(collection, 2)

    expect(scores.first).to eq(has_comment)
  end

  it "returns a result with a 2-weighted judge comment over 1-weighted results" do
    skip
    one_weighted = double(:one_weighted, id: 0, one_weighted_comment: "hello")
    two_weighted = double(:two_weighted, id: 1, two_weighted_comment: "hello!")
    collection = [one_weighted, two_weighted]

    allow(MeaningfulScores).to receive(:config) { interesting_config }

    scores = MeaningfulScores.new(collection, 2)

    expect(scores.first).to eq(two_weighted)
  end

  it "returns a result with a 3-weighted judge comment over 1- and 2-weighted results"

  it "selects the top <limit> scores sorted descending by varied weights"

  def basic_config
    {
      "category1" => {
        "weight" => 1,
        "field" => {}
      }
    }
  end

  def interesting_config
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
