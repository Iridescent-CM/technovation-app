class Document < ActiveRecord::Base
  belongs_to :signer, polymorphic: true

  after_update :update_signer_onboarding_status

  def signed?
    signed_at.present?
  end

  private

  def update_signer_onboarding_status
    if signer_type == "ChapterAmbassadorProfile"
      signer.update_onboarding_status
    end
  end
end
