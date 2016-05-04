class CalculateScore
  class << self
    def call(rubric)
      initial_score = scoring_attributes.inject(0) do |accumulator, attr|
        accumulator + rubric.send(attr)
      end

      extra_score = rubric.launched ? 2 : 0

      rubric.score = initial_score + extra_score
    end

    def scoring_attributes
      %i{identify_problem address_problem functional external_resources
          match_features interface description market competition
          revenue branding pitch}
    end
  end
end
