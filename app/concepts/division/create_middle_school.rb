class Division < ActiveRecord::Base
  class CreateMiddleSchool < Create
    def process(params)
      super(params.deep_merge(division: { name: :middle_school }))
    end
  end
end
