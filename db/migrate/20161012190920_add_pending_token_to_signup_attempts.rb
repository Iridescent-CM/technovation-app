class AddPendingTokenToSignupAttempts < ActiveRecord::Migration
  def change
    add_column :signup_attempts, :pending_token, :string
    add_index :signup_attempts, :pending_token
  end
end
