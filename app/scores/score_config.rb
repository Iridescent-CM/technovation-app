class ScoreConfig
  def self.fields(category_name)
    category_data = loaded_config.fetch(String(category_name)) { {} }
    category_data.keys - ['weight']
  end

  def self.field(field_name)
    loaded_config.values.detect { |weight_and_fields|
      weight_and_fields.keys.include?(String(field_name))
    }.fetch(String(field_name))
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
