class AddLocationToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :city, :string
    add_column :signup_attempts, :state_code, :string
    add_column :signup_attempts, :country_code, :string
    add_column :signup_attempts, :latitude, :decimal, precision: 10, scale: 6
    add_column :signup_attempts, :longitude, :decimal, precision: 10, scale: 6
  end
end
