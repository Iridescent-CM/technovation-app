class ParentalConsent < ActiveRecord::Base
  belongs_to :student, foreign_key: :account_id

  scope :nonvoid, -> { where('voided_at IS NULL') }

  validates :electronic_signature, presence: true

  delegate :full_name, :consent_token, to: :student, prefix: true

  after_commit -> {
    after_create_student_actions
    after_create_parent_actions
  }, on: :create

  def student_consent_token=(token)
    self.student = Account.find_by(consent_token: token)
  end

  def signed_at
    created_at
  end

  def void!
    update_attributes(voided_at: Time.current)
  end

  def voided?
    !!voided_at
  end
  alias void? voided?

  def after_create_student_actions
    SubscribeEmailListJob.perform_later(student.email,
                                        student.full_name,
                                        "STUDENT_LIST_ID")

    AccountMailer.confirm_next_steps(self).deliver_later
  end

  def after_create_parent_actions
    SubscribeEmailListJob.perform_later(student.parent_guardian_email,
                                        student.parent_guardian_name,
                                        "PARENT_LIST_ID")

    ParentMailer.confirm_consent_finished(self).deliver_later
  end
end
