module CreateScoringRubric
  def self.call(attributes)
    category = create_score_category(attributes.fetch(:category))
    build_score_attributes(category, attributes.fetch(:attributes))
    category.save
    category
  end

  private
  def self.create_score_category(name)
    ScoreCategory.find_or_create_by(name: name)
  end

  def self.build_score_attributes(category, attributes)
    attributes.each do |attr|
      attribute = category.score_attributes.build(label: attr.fetch(:label))
      build_score_values(attribute, attr.fetch(:values))
    end
  end

  def self.build_score_values(score_attribute, value_attributes)
    value_attributes.each do |value|
      score_attribute.score_values.build(label: value.fetch(:label),
                                         value: value.fetch(:value))
    end
  end
end
