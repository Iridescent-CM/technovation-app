class JudgeProfile < ActiveRecord::Base
  include Authenticatable

  has_many :judge_scoring_expertises
  has_many :scoring_expertises, through: :judge_scoring_expertises

  has_many :scores

  validates :company_name,
            :job_title,
            presence: true

  def scored_submission_ids
    scores.flat_map(&:submission_id)
  end
end
