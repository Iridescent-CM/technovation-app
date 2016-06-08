class ScoreCategory < ActiveRecord::Base
  has_many :score_attributes
  accepts_nested_attributes_for :score_attributes
end
