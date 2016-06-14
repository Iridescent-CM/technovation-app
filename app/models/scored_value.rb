class ScoredValue < ActiveRecord::Base
  belongs_to :score
  belongs_to :score_value
end
