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
    max_score_values.reduce(0) { |s, i| s + i }
  end

  def self.fields(category_name)
    category_data = config.fetch(String(category_name)) { {} }
    category_data.keys
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

  def config
    @config ||= self.class.config.fetch(@category).fetch(@field)
  end

  def self.config
    @@config ||= YAML.load_file('./config/score_fields.yml')
  end

  private
  def values
    config.fetch('values')
  end

  def self.max_score_values
    config.values.flat_map(&:values).flat_map { |i| i.fetch('values').keys.map(&:to_i).max }
  end
end
