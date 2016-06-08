class Division < ActiveRecord::Base
  class CreateHighSchool < Create
    def process(params)
      super(params.deep_merge(division: { name: :high_school }))
    end
  end
end
