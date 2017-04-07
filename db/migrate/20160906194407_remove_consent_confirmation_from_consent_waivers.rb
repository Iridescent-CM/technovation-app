class RemoveConsentConfirmationFromConsentWaivers < ActiveRecord::Migration[4.2]
  def change
    remove_column :consent_waivers, :consent_confirmation, :boolean
  end
end
