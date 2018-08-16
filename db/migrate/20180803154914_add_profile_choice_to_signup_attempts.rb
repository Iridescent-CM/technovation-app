class AddProfileChoiceToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :profile_choice, :integer
  end
end
