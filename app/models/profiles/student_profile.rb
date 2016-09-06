class StudentProfile < ActiveRecord::Base
  include Authenticatable

  belongs_to :student_account, foreign_key: :account_id

  after_update :reset_parent,
    if: :parent_guardian_email_changed?

  validates :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
    presence: true

  validates :parent_guardian_email, email: true

  private
  def reset_parent
    student_account.void_parental_consent!
    ParentMailer.consent_notice(parent_guardian_email,
                                student_account.consent_token).deliver_later
    UpdateEmailListJob.perform_later(parent_guardian_email_was,
                                     parent_guardian_email,
                                     parent_guardian_name,
                                     ENV.fetch("PARENT_LIST_ID"))
  end
end
