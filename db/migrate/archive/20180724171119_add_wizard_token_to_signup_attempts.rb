class AddWizardTokenToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :wizard_token, :string
  end
end
