class StudentProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :student_account, foreign_key: :account_id

  after_save :resend_parental_consent, if: -> { parent_guardian_email_changed? }

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
            :is_in_secondary_school,
            presence: true

  validates :parent_guardian_email, email: true

  private
  def resend_parental_consent
    ParentMailer.consent_notice(student_account).deliver_later
  end
end
