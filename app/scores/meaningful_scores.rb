require "./app/scores/score_config"

class MeaningfulScores
  WeightedScore = Struct.new(:score, :weight)

  include Enumerable

  def initialize(score_or_scores, limit = 0)
    scores = Array(score_or_scores)
    @scores = weigh_scores(scores).max_by(limit, &:weight).map(&:score)
  end

  def each(&block)
    if block_given?
      @scores.each { |s| block.call(s) }
    else
      @scores.each
    end
  end

  def empty?
    !@scores.any?
  end

  def last
    @scores[-1]
  end

  def self.config
    ScoreConfig
  end

  private
  def weigh_scores(scores)
    scores.flat_map do |score|
      WeightedScore.new(score, self.class.config.weigh_score(score))
    end
  end
end
