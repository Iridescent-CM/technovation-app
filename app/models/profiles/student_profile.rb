class StudentProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :student_account, foreign_key: :account_id

  after_save :resend_parental_consent,
             :void_parental_consent,
    if: :persisted_parent_guardian_email_changed?

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
            :is_in_secondary_school,
    presence: true

  validates :parent_guardian_email, email: true

  private
  def persisted_parent_guardian_email_changed?
    persisted? && parent_guardian_email_changed?
  end

  def resend_parental_consent
    ParentMailer.consent_notice(student_account).deliver_later
  end

  def void_parental_consent
    student_account.void_parental_consent!
  end
end
