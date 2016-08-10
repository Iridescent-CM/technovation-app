class StudentProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :student_account, foreign_key: :account_id

  after_validation :resend_parental_consent,
                   :void_parental_consent,
    on: :update,
    if: :parent_guardian_email_changed?

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
            :is_in_secondary_school,
    presence: true

  validates :parent_guardian_email, email: true

  private
  def resend_parental_consent
    ParentMailer.consent_notice(parent_guardian_email,
                                student_account.consent_token).deliver_later
  end

  def void_parental_consent
    student_account.void_parental_consent!
  end
end
