require "spec_helper"

class MeaningfulScores
  include Enumerable

  def initialize(score_or_scores, limit = 0)
    @scores = Array(score_or_scores).first(limit)
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

  def self.config
  end
end

RSpec.describe "Select meaningful scores" do
  it "is empty for no scores" do
    scores = MeaningfulScores.new([])
    expect(scores).to be_empty
  end

  it "returns <limit> scores for a given limit" do
    collection = [double] * 2
    scores = MeaningfulScores.new(collection, 1)
    expect(scores.count).to eq(1)
  end

  it "returns the first <limit> scores when all the judge comments are empty" do
    collection = 2.times.map { |n| double(:score, id: n, attribute_comment: "") }

    allow(MeaningfulScores).to receive(:config) { basic_config }

    scores = MeaningfulScores.new(collection, 1)
    expect(scores.last.id).to eq(0)
  end

  it "returns a result with a 1-weighted judge comment at the top"
  it "returns a result with a 2-weighted judge comment over 1-weighted results"
  it "returns a result with a 3-weighted judge comment over 1- and 2-weighted results"

  it "selects the top <limit> scores sorted descending by varied weights"

  def basic_config
    { "category_name" => { "attribute" => {} } }
  end
end
