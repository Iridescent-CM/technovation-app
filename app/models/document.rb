class Document < ActiveRecord::Base
  belongs_to :signer, polymorphic: true

  before_save :set_status
  after_update -> { signer.update_onboarding_status }

  enum status: {sent: "sent", signed: "signed", voided: "voided"}

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
