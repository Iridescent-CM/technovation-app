module CreateScoringRubric
  def self.call(rubric_or_rubrics)
    [rubric_or_rubrics].flatten.map { |attributes|
      category = create_score_category(attributes.fetch(:category),
                                       attributes.fetch(:expertise) { true })
      build_score_questions(category, attributes.fetch(:questions) { { } })
      category.save
      category
    }.all?(&:valid?)
  end

  private
  def self.create_score_category(name, expertise)
    ScoreCategory.find_or_create_by(name: name, is_expertise: expertise)
  end

  def self.build_score_questions(category, attributes)
    attributes.each do |attr|
      question = category.score_questions.build(label: attr.fetch(:label))
      build_score_values(question, attr.fetch(:values))
    end
  end

  def self.build_score_values(score_question, value_attributes)
    value_attributes.each do |value|
      score_question.score_values.build(label: value.fetch(:label),
                                         value: value.fetch(:value))
    end
  end
end
