class AddPasswordDigestToSignupAttempts < ActiveRecord::Migration[4.2]
  def change
    add_column :signup_attempts, :password_digest, :string
  end
end
