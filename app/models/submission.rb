class Submission < ActiveRecord::Base
  belongs_to :team
  has_many :scores
end
