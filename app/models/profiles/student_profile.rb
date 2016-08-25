class StudentProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :student_account, foreign_key: :account_id

  after_update :reset_parental_consent,
    if: :parent_guardian_email_changed?

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
    presence: true

  validates :parent_guardian_email, email: true

  private
  def reset_parental_consent
    student_account.void_parental_consent!
    ParentMailer.consent_notice(parent_guardian_email,
                                student_account.consent_token).deliver_later
  end
end
