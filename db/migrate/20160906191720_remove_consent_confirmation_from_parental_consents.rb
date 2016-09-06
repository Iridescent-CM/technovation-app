class RemoveConsentConfirmationFromParentalConsents < ActiveRecord::Migration
  def change
    remove_column :parental_consents, :consent_confirmation, :boolean
  end
end
