require "reform/form/validation/unique_validator"

class Division < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Division, :create

    contract do
      property :name

      validates :name, unique: true,
                       presence: true,
                       inclusion: { in: Division.names.keys +
                                          Division.names.values +
                                            Division.names.keys.map(&:to_sym) }
    end

    def process(params)
      validate(sanitize_division_params(params)) do |f|
        f.save
      end
    end

    private
    def sanitize_division_params(params)
      name = params.fetch(:division) { {} }.fetch(:name)
      params.deep_merge(division: { name: Division.names[name] })[:division]
    end
  end

  class CreateHighSchool < Create
    def process(params)
      params.deep_merge!(division: { name: :high_school })
      super(params)
    end
  end

  class CreateMiddleSchool < Create
    def process(params)
      params.deep_merge!(division: { name: :middle_school })
      super(params)
    end
  end
end
