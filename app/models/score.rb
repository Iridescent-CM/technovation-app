class Score
  PossibleValue = Struct.new(:value, :explanation)

  attr_reader :value

  def initialize(rubric, field)
    @rubric = rubric
    @field = field.to_s
    @value = @rubric.public_send(@field)
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
    @config ||= YAML.load_file('./config/score_fields.yml').fetch(@field)
  end
end
