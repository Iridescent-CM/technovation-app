class Document < ActiveRecord::Base
  belongs_to :signer, polymorphic: true

  after_update -> { signer.update_onboarding_status }

  def signed?
    signed_at.present?
  end
end
