class ParentalConsent < ActiveRecord::Base
  belongs_to :student, class_name: "StudentAccount", foreign_key: :account_id

  validates :electronic_signature, presence: true
  validates :consent_confirmation, inclusion: { in: [1] }

  delegate :full_name, to: :student, prefix: true

  def student_consent_token=(token)
    self.student = StudentAccount.find_by(consent_token: token)
  end

  def signed_at
    created_at
  end
end
