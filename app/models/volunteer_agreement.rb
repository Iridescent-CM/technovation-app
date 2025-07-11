class VolunteerAgreement < ActiveRecord::Base
  belongs_to :profile, polymorphic: true
  validates :electronic_signature, presence: true

  scope :nonvoid, -> { where(voided_at: nil) }
  scope :void, -> { where.not(voided_at: nil) }

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
