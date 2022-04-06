class MediaConsent < ActiveRecord::Base
  ELECTRONIC_SIGNATURE_FOR_A_PAPER_MEDIA_CONSENT = "ON FILE"

  belongs_to :student_profile

  validates :season, presence: true
  validates :electronic_signature, presence: true, on: :update
  validates :consent_provided, inclusion: [false, true], on: :update

  after_commit :send_media_conent_confirmation_email_to_parent,
    if: proc { |media_consent| media_consent.signed? }

  def signed?
    electronic_signature.present?
  end

  def unsigned?
    electronic_signature.blank?
  end

  def on_file?
    electronic_signature === ELECTRONIC_SIGNATURE_FOR_A_PAPER_MEDIA_CONSENT
  end

  private

  def send_media_conent_confirmation_email_to_parent
    ParentMailer.confirm_media_consent_finished(student_profile.id).deliver_later
  end
end
