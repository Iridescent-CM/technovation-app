module RequireParentalConsentSigned
  extend ActiveSupport::Concern

  included do
    before_action :require_parental_consent_signed
  end

  private

  def require_parental_consent_signed
    redirect_to student_profile_path unless current_student.parental_consent&.signed?
  end
end
