class ScoreField
  ValueLabel = Struct.new(:value, :label)

  def initialize(field)
    @field = String(field)
  end

  def value_labels
    @values ||= config.values.map do |value, label|
      ValueLabel.new(value, label)
    end
  end

  def label
    config.label
  end

  private
  def config
    ScoreConfig.field(@field)
  end
end
