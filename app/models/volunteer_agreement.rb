class VolunteerAgreement < ActiveRecord::Base
  belongs_to :ambassador, polymorphic: true
  validates :electronic_signature, presence: true

  scope :nonvoid, -> { where(voided_at: nil) }
  scope :void, -> { where.not(voided_at: nil) }

  after_save -> { ambassador.update_onboarding_status }

  def signed_at
    created_at
  end

  def signed?
    !voided?
  end

  def void!
    update(voided_at: Time.current)
  end

  def voided?
    !!voided_at
  end
end
