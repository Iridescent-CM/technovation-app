require "./app/scores/score_config"

class Score
  PossibleValue = Struct.new(:value, :explanation)

  attr_reader :value

  def initialize(rubric, field)
    @rubric = rubric
    @field = String(field)
    @value = @rubric.score_value(@field)
  end

  def self.total_possible
    ScoreConfig.max_score_values.reduce(0) { |s, i| s + i }
  end

  def field_name
    @field
  end

  def label
    config.label
  end

  def explanation
    config.explanation(value)
  end

  def possible_scores
    config.values_not(value).map do |value, explanation|
      PossibleValue.new(value, explanation)
    end
  end

  private
  def config
    ScoreConfig.field(@field)
  end
end
