class MeaningfulScores
  WeightedScore = Struct.new(:score, :weight)

  include Enumerable

  def initialize(score_or_scores, limit = 0)
    scores = Array(score_or_scores)
    @scores = weigh_scores(scores).max_by(limit) { |w| w.weight }
                                  .collect(&:score)
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

  private
  def weigh_scores(scores)
    self.class.config.flat_map do |_, weight_and_fields|
      scores.flat_map do |score|
        WeightedScore.new(score, weigh_score(score, weight_and_fields))
      end
    end
  end

  def weigh_score(score, weight_and_fields)
    category_weight = weight_and_fields.fetch('weight')
    fields = (weight_and_fields.keys - ['weight'])

    initial_weight = category_weight * score.provided_feedback_count(*fields)

    initial_weight * adjusted_category_weight(category_weight)
  end

  def adjusted_category_weight(category_weight)
    Float(category_weight) / heaviest_weight
  end

  def heaviest_weight
    self.class.config.values.max_by { |v| v == 'value' }.fetch('weight')
  end
end
