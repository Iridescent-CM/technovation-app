class CreateBasicProfiles < ActiveRecord::Migration
  def change
    create_table :basic_profiles do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :date_of_birth, null: false
      t.string :city, null: false
      t.string :region, null: false
      t.string :country, null: false
      t.date :consent_signed_at

      t.integer :account_id, foreign_key: true, index: true, null: false

      t.timestamps null: false
    end
  end
end
