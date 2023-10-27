class ParentalConsentPolicy < ApplicationPolicy
  def show?
    current_account.student_profile.present? && (current_account.student_profile.id == record.student_profile_id) ||
      current_account.admin?
  end
end
