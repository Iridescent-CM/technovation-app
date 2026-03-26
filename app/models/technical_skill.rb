class TechnicalSkill < ApplicationRecord
  has_many :judge_profile_technical_skills
  has_many :judge_profiles, through: :judge_profile_technical_skills

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
