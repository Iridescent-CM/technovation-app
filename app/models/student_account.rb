class StudentAccount < Account
  default_scope { joins(:student_profile) }

  delegate :parent_guardian_email,
           :parent_guardian_name,
           :school_name,
           :completion_requirements,
    to: :student_profile,
    prefix: false
end
