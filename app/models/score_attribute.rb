class ScoreAttribute < ActiveRecord::Base
  belongs_to :score_category
  has_many :score_values
end
