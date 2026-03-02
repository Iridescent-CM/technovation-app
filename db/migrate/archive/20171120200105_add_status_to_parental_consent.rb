class AddStatusToParentalConsent < ActiveRecord::Migration[5.1]
  def change
    add_column :parental_consents, :status, :integer, null: false, default: 0
    change_column_null :parental_consents, :electronic_signature, true
  end
end
