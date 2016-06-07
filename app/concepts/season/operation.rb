class Season < ActiveRecord::Base
  class Current < Trailblazer::Operation
    def process(params)
      @model = Season.find_or_create_by(year: Time.current.year,
                                        starts_at: Time.current - 30.days)
    end
  end
end
