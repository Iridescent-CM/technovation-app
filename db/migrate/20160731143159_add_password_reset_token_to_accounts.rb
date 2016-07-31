class AddPasswordResetTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :password_reset_token, :string
    add_index :accounts, :password_reset_token, unique: true
    add_column :accounts, :password_reset_token_sent_at, :datetime
    add_index :accounts, :password_reset_token_sent_at
  end
end
