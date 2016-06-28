class StudentProfile < ActiveRecord::Base
  include Authenticatable

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
            presence: true

  def profile_completion_requirements
    reqs = {}
    reqs[:complete_pre_program_survey] = '#' unless pre_survey_completed?
    reqs[:resend_parental_consent] = '#' unless parental_consent_signed?
    reqs
  end

  def complete_pre_program_survey!
    update_attributes(pre_survey_completed_at: Time.current)
  end

  def sign_parental_consent_form!
    authentication.profile_sign_consent_form!
  end

  private
  def pre_survey_completed?
    !!pre_survey_completed_at # and pre_survey_completed_at >= Date.new(2016, 9, 1)
  end

  def parental_consent_signed?
    !!authentication.profile_consent_signed_at # and authentication.profile_consent_signed_at >= Date.new(2016, 9, 1)
  end
end
