class AddConsentTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :consent_token, :string
    add_index :accounts, :consent_token, unique: true
  end
end
