class Feedback < ActiveRecord::Base
  belongs_to :score_value

  def total_score
    score_value.value
  end
end
