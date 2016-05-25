class MeaningfulScores
  WeightedScore = Struct.new(:score, :weight)

  include Enumerable

  def initialize(score_or_scores, limit = 0)
    scores = Array(score_or_scores)
    @scores = weigh_scores(scores).max_by(limit) { |w| w.weight }
                                  .collect(&:score)
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
    YAML.load_file('./config/score_fields.yml')
  end

  private
  def weigh_scores(scores)
    scores.flat_map do |score|
      WeightedScore.new(score, weigh_score(score))
    end
  end

  def weigh_score(score)
    self.class.config.reduce(0) do |sum, (_, weight_and_fields)|
      category_weight = weight_and_fields.fetch('weight') { 0 }
      fields = (weight_and_fields.keys - ['weight'])

      initial_weight = category_weight * score.provided_feedback_count(*fields)

      sum + (initial_weight * adjusted_category_weight(category_weight))
    end
  end

  def adjusted_category_weight(category_weight)
    Float(category_weight) / heaviest_weight
  end

  def heaviest_weight
    self.class.config.values.max_by { |h| h.fetch('weight') { 0 } }.fetch('weight')
  end
end
