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

  def self.loaded_config
    YAML.load_file(filepath)
  end

  def self.filepath
    './config/score_fields.yml'
  end
end
