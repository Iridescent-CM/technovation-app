class AddSessionTokenToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :session_token, :string
    add_index :accounts, :session_token, unique: true
  end
end
