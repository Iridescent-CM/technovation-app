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

  def sent?
    sent_at.present?
  end

  def complete?
    signed? || off_platform?
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
