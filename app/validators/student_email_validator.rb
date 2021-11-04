class StudentEmailValidator < ActiveModel::Validator
  def validate(record)
    if record.student_profile.present? &&
        record.date_of_birth.present? &&
        ["senior", "junior"].include?(Division.for_account(record).name) &&
        (record.email == record.student_profile.parent_guardian_email)

      record.errors.add(:email, :matches_parent_guardian_email)
    end
  end
end
