require "reform/form/validation/unique_validator"

class Season < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Season, :create

    contract do
      property :year
      property :starts_at

      validates :year, presence: true, numericality: true, unique: true
      validates :starts_at, presence: true
    end

    def process(params)
      validate(params[:season]) do |f|
        f.save
      end
    end
  end
end
