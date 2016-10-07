class CreateSignupAttempts < ActiveRecord::Migration
  def change
    create_table :signup_attempts do |t|
      t.string :email, null: false
      t.string :activation_token, null: false
      t.references :account, index: true, foreign_key: true
      t.integer :status, null: false, default: SignupAttempt.statuses[:pending]

      t.timestamps null: false
    end
    add_index :signup_attempts, :email
    add_index :signup_attempts, :activation_token
    add_index :signup_attempts, :status
  end
end
