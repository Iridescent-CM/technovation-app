class JudgeType < ActiveRecord::Base
  has_many :judge_profile_judge_types, dependent: :destroy
  has_many :judge_profiles, through: :judge_profile_judge_types

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
