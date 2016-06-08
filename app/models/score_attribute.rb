class ScoreAttribute < ActiveRecord::Base
  belongs_to :score_category
  has_many :score_values
  accepts_nested_attributes_for :score_values
end
