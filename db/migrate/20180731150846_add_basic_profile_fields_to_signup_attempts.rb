class AddBasicProfileFieldsToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :first_name, :string
    add_column :signup_attempts, :last_name, :string
    add_column :signup_attempts, :gender_identity, :integer
    add_column :signup_attempts, :school_company_name, :string
    add_column :signup_attempts, :referred_by, :integer
    add_column :signup_attempts, :referred_by_other, :string
  end
end
