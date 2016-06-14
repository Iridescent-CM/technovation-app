class JudgingEnabledUserRole < UserRole
  has_many :judge_expertises
  has_many :expertises, through: :judge_expertises
end
