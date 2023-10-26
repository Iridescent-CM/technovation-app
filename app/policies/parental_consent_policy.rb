class ParentalConsentPolicy < ApplicationPolicy
  def show?
    current_account.admin? ||
      record.student_profile_id == current_account&.student_profile&.id
  end
end
