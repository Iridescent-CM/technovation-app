class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :auth_token, null: false

      t.string :first_name, null: false
      t.string :last_name, null: false

      t.date :date_of_birth, null: false

      t.string :city, null: false
      t.string :state_province, null: false
      t.string :country, null: false

      t.string :type, index: true, null: false

      t.integer :referred_by, index: true
      t.string :referred_by_other

      t.timestamps null: false
    end
    add_index :accounts, :email, unique: true
    add_index :accounts, :auth_token, unique: true
  end
end
