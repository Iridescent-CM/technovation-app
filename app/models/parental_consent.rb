class ParentalConsent < ActiveRecord::Base
  belongs_to :student, class_name: "StudentAccount", foreign_key: :account_id

  scope :nonvoid, -> { where('voided_at IS NULL') }

  validates :electronic_signature, presence: true

  delegate :full_name, :consent_token, to: :student, prefix: true

  after_create -> {
    SubscribeEmailListJob.perform_later(student.email,
                                        student.full_name,
                                        ENV.fetch("STUDENT_LIST_ID"))

    SubscribeEmailListJob.perform_later(student.parent_guardian_email,
                                        student.parent_guardian_name,
                                        ENV.fetch("PARENT_LIST_ID"))

    AccountMailer.confirm_next_steps(self).deliver_later

    ParentMailer.confirm_consent_finished(self).deliver_later
  }

  def student_consent_token=(token)
    self.student = StudentAccount.find_by(consent_token: token)
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
end
