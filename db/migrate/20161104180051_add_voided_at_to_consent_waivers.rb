class AddVoidedAtToConsentWaivers < ActiveRecord::Migration
  def change
    add_column :consent_waivers, :voided_at, :datetime
  end
end
