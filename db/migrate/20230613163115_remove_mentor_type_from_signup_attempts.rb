class RemoveMentorTypeFromSignupAttempts < ActiveRecord::Migration[6.1]
  def change
    remove_column :signup_attempts, :mentor_type
  end
end
