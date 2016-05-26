class ScoreConfig
  def self.field(field_name)
    loaded_config.values.detect { |weight_and_fields|
      weight_and_fields.keys.include?(String(field_name))
    }.fetch(String(field_name))
  end

  def self.filepath
    './config/score_fields.yml'
  end

  def self.loaded_config
    YAML.load_file(filepath)
  end
end
