module CreateScoringRubric
  def self.call(attributes)
    category = ScoreCategory.find_or_create_by(name: attributes.fetch(:category))

    attributes.fetch(:attributes).each do |attr|
      attribute = category.score_attributes.build(label: attr.fetch(:label))

      attr.fetch(:values).each do |value|
        attribute.score_values.build(label: value.fetch(:label), value: value.fetch(:value))
      end
    end

    category.save
    category
  end
end
