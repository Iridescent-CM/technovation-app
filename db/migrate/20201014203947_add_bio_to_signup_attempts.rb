class AddBioToSignupAttempts < ActiveRecord::Migration[5.2]
  def change
    add_column :signup_attempts, :bio, :string
  end
end
