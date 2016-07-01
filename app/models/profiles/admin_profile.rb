class AdminProfile < ActiveRecord::Base
  include Authenticatable

  has_many :scores, foreign_key: :judge_profile_id

  def scored_submission_ids
    scores.flat_map(&:submission_id)
  end
end
