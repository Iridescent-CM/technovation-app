class MediaConsent < ActiveRecord::Base
  belongs_to :student_profile

  validates :season, presence: true
  validates :electronic_signature, presence: true, on: :update
  validates :consent_provided, inclusion: [false, true], on: :update

  def signed?
    electronic_signature.present?
  end

  def unsigned?
    electronic_signature.blank?
  end
end
