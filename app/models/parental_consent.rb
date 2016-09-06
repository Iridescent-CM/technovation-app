class ParentalConsent < ActiveRecord::Base
  belongs_to :student, class_name: "StudentAccount", foreign_key: :account_id

  scope :nonvoid, -> { where('voided_at IS NULL') }

  validates :electronic_signature, presence: true

  delegate :full_name, :consent_token, to: :student, prefix: true

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
