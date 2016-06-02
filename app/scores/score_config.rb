class ScoreConfig
  Field = Struct.new(:field) do
    def values_not(value)
      values.select { |k, _| k != value }
    end

    def explanation(value)
      field.values.fetch(value)
    end

    def label
      field.fetch('label')
    end

    def values
      field.fetch('values')
    end
  end

  def self.fields(category_name)
    category_data = loaded_config.fetch(String(category_name)) { {} }
    category_data.keys - ['weight']
  end

  def self.field(field_name)
    Field.new(
      loaded_config.values.detect { |weight_and_fields|
        weight_and_fields.keys.include?(String(field_name))
      }.fetch(String(field_name))
    )
  end

  def self.max_score_values
    loaded_config.values.flat_map(&:values).select { |i|
      i.respond_to?(:fetch)
    }.flat_map do |i|
      i.fetch('values').keys.map(&:to_i).max
    end
  end

  def self.weigh_score(score)
    loaded_config.reduce(0) do |sum, (_, weight_and_fields)|
      category_weight = weight_and_fields.fetch('weight') { 0 }
      fields = (weight_and_fields.keys - ['weight'])

      initial_weight = category_weight * score.provided_feedback_count(*fields)

      sum + (initial_weight * adjusted_category_weight(category_weight))
    end
  end

  def self.loaded_config
    YAML.load_file(filepath)
  end

  def self.filepath
    './config/score_fields.yml'
  end

  private
  def self.adjusted_category_weight(category_weight)
    Float(category_weight) / ScoreConfig.heaviest_weight
  end

  def self.heaviest_weight
    loaded_config.values.max_by { |h| h.fetch('weight') { 0 } }
                        .fetch('weight')
  end
end
