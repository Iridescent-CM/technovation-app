class ScoreField
  ValueLabel = Struct.new(:value, :label)

  def initialize(category, field)
    @category = String(category)
    @field = String(field)
  end

  def value_labels
    @values ||= config.fetch('values').map do |value, label|
      ValueLabel.new(value, label)
    end
  end

  def label
    @label ||= config.fetch('label')
  end

  private
  def config
    @config ||= YAML.load_file('./config/score_fields.yml').fetch(@category).fetch(@field)
  end
end
