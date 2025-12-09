class CreateParentalConsentRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :parental_consent_requests do |t|
      t.references :student_profile, index: true, foreign_key: true
      t.integer :season, null: false, limit: 2
      t.integer :delivery_method, null: false
      t.string :external_message_id
      t.string :recipient
      t.datetime :sent_at, null: false

      t.timestamps
    end
  end
end
