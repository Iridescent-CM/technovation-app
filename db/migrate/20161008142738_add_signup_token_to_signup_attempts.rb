class AddSignupTokenToSignupAttempts < ActiveRecord::Migration
  def change
    add_column :signup_attempts, :signup_token, :string
    add_index :signup_attempts, :signup_token
  end
end
