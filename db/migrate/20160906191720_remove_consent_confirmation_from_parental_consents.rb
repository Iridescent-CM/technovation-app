class RemoveConsentConfirmationFromParentalConsents < ActiveRecord::Migration[4.2]
  def change
    remove_column :parental_consents, :consent_confirmation, :boolean
  end
end
