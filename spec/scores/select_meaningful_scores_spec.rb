require "spec_helper"

class MeaningfulScores
  include Enumerable

  def initialize(score_or_scores, limit = 0)
    scores = Array(score_or_scores)
    commented = scores.select { |score| !score.field_comment.empty? }
    sorted = commented | scores
    @scores = sorted.first(limit)
  end

  def each(&block)
    @scores.each { |s| block.call(s) }
  end

  def empty?
    !@scores.any?
  end

  def last
    @scores[-1]
  end
end

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

    scores = MeaningfulScores.new(collection, 2)

    expect(scores.first).to eq(has_comment)
  end

  it "returns a result with a 2-weighted judge comment over 1-weighted results"
  it "returns a result with a 3-weighted judge comment over 1- and 2-weighted results"

  it "selects the top <limit> scores sorted descending by varied weights"
end
