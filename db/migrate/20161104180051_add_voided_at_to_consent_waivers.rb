class AddVoidedAtToConsentWaivers < ActiveRecord::Migration[4.2]
  def change
    add_column :consent_waivers, :voided_at, :datetime
  end
end
