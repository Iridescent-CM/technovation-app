class ScoreCategory < ActiveRecord::Base
  has_many :score_attributes
end
