class Submission < ActiveRecord::Base
  belongs_to :team
  has_many :scores

  delegate :name, to: :team, prefix: true
end
