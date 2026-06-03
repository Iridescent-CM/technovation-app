class AddTermsAgreedAtToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :terms_agreed_at, :datetime
  end
end
