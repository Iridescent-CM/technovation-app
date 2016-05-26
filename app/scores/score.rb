require "./app/scores/score_config"

class Score
  PossibleValue = Struct.new(:value, :explanation)

  attr_reader :value

  def initialize(rubric, category, field)
    @rubric = rubric
    @category = String(category)
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
    config.fetch('label')
  end

  def explanation
    values.fetch(value)
  end

  def possible_scores
    other_values = values.select { |k| k != value }
    other_values.map do |value, explanation|
      PossibleValue.new(value, explanation)
    end
  end

  private
  def values
    config.fetch('values')
  end

  def config
    ScoreConfig.field(@field)
  end
end
