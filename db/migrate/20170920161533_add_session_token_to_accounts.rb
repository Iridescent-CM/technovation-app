class AddSessionTokenToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :session_token, :string
  end
end
