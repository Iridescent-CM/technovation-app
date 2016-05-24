class MeaningfulScores
  include Enumerable

  def initialize(score_or_scores, limit = 0)
    scores = Array(score_or_scores)
    commented = self.class.config.flat_map do |category, weight_and_fields|
                  (weight_and_fields.keys - ['weight']).flat_map do |field|
                    scores.select do |score|
                      !score.public_send("#{field}_comment").empty?
                    end
                  end
                end
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

  def self.config
    {}
  end
end
