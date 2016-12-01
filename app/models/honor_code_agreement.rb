class HonorCodeAgreement < ActiveRecord::Base
  belongs_to :account

  scope :nonvoid, -> { where('voided_at IS NULL') }
  scope :void, -> { where('voided_at IS NOT NULL') }

  validates :agreement_confirmed, acceptance: { accept: true }
  validates :electronic_signature, presence: true

  def void!
    update_attributes(voided_at: Time.current)
  end
end
