class JudgeProfile < ActiveRecord::Base
  include Authenticatable

  has_many :judge_expertises
  has_many :expertises, through: :judge_expertises

  has_many :scores

  def scored_submission_ids
    scores.flat_map(&:submission_id)
  end
end
