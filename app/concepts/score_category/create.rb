require "reform/form/validation/unique_validator"

class ScoreCategory < ActiveRecord::Base
  class Create < Trailblazer::Operation
    def process(params)
      @model = ScoreCategory.create!(params.fetch(:score_category))
    end
  end
end
