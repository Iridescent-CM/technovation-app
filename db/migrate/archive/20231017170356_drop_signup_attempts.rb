class DropSignupAttempts < ActiveRecord::Migration[6.1]
  def change
    drop_table :signup_attempts
  end
end
