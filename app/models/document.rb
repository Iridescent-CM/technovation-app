class Document < ActiveRecord::Base
  belongs_to :signer, polymorphic: true

  before_save :set_status
  after_save -> { signer.update_onboarding_status }

  enum status: {
    sent: "sent",
    signed: "signed",
    "off-platform": "off-platform",
    voided: "voided"
  }

  def unsigned?
    sent? && signed_at.blank?
  end

  def complete?
    signed? || off_platform?
  end

  def expired?
    !!sent_at&.before?(ENV.fetch("DOCUSIGN_NUM_DAYS_DOCUMENTS_EXPIRE_IN", 120).to_i.days.ago)
  end

  def document_type
    case signer_type
    when "LegalContact"
      "Chapter Affiliation Agreement"
    when "ChapterAmbassadorProfile"
      "Chapter Volunteer Agreement"
    end
  end

  private

  def set_status
    if sent_at_changed? && sent_at.present?
      self.status = :sent
    elsif signed_at_changed? && signed_at.present?
      self.status = :signed
    elsif voided_at_changed? && voided_at.present?
      self.status = :voided
    end
  end
end
