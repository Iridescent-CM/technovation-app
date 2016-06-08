require "reform/form/validation/unique_validator"

class Region < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Region, :create

    contract do
      property :name
      validates :name, presence: true, unique: true
    end

    def process(params)
      validate(params.fetch(:region)) do |f|
        f.save
      end
    end
  end
end
