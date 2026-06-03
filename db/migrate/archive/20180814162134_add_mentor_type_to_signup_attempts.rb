class AddMentorTypeToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :mentor_type, :integer
  end
end
