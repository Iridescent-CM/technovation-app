class AddConsentTokenToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :consent_token, :string
    add_index :accounts, :consent_token, unique: true
  end
end
