class AddBirthdatesToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :birth_year, :integer
    add_column :signup_attempts, :birth_month, :integer
    add_column :signup_attempts, :birth_day, :integer
  end
end
