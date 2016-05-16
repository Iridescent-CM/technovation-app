class ScoreField
  ValueLabel = Struct.new(:value, :label)

  def initialize(field)
    @field = field.to_s
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
    @config ||= YAML.load_file('./config/score_fields.yml').fetch(@field)
  end
end
