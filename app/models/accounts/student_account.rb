class StudentAccount < Account
  default_scope { joins(:student_profile) }

  after_initialize :build_student_profile, if: -> { student_profile.blank? }

  has_one :student_profile, foreign_key: :account_id
  accepts_nested_attributes_for :student_profile
  validates_associated :student_profile

  delegate :is_in_secondary_school?,
           :is_in_secondary_school,
           :parent_guardian_email,
           :parent_guardian_name,
           :school_name,
           :completion_requirements,
    to: :student_profile,
    prefix: false
end
