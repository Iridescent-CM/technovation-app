class Season < ActiveRecord::Base
  class Current < Trailblazer::Operation
    def process(params)
      @model = Season.find_by(year: Time.current.year)
    end
  end
end
