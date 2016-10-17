class AddPasswordDigestToSignupAttempts < ActiveRecord::Migration
  def change
    add_column :signup_attempts, :password_digest, :string
  end
end
