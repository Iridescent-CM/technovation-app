class MediaConsent < ActiveRecord::Base
  enum upload_approval_status: ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES, _prefix: true

  belongs_to :student_profile

  mount_uploader :uploaded_consent_form, PaperParentalConsentUploader

  validates :season, presence: true
  validates :electronic_signature, presence: true, on: :update, unless: :uploaded?
  validates :consent_provided, inclusion: [false, true], on: :update, if: :signed?

  before_validation -> {
    if uploaded_consent_form_changed?
      self.uploaded_at = Time.now
    end
  }

  before_save -> {
    if uploaded_at_changed?
      self.upload_approval_status = ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:pending]
      self.upload_approved_at = nil
      self.upload_rejected_at = nil
    end
  }

  delegate :email, :full_name,
    to: :student_profile,
    prefix: true

  def signed?
    electronic_signature.present?
  end

  def unsigned?
    electronic_signature.blank?
  end

  def on_file?
    electronic_signature === ConsentForms::ELECTRONIC_SIGNATURE_FOR_A_PAPER_CONSENT
  end

  def uploaded?
    uploaded_at.present?
  end
end
