class RemoveConsentConfirmationFromConsentWaivers < ActiveRecord::Migration
  def change
    remove_column :consent_waivers, :consent_confirmation, :boolean
  end
end
