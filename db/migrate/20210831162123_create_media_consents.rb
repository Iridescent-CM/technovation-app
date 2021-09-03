class CreateMediaConsents < ActiveRecord::Migration[6.1]
  def change
    create_table :media_consents do |t|
      t.integer :student_profile_id, null: false
      t.integer :season, null: false, limit: 2
      t.boolean :consent_provided
      t.string :electronic_signature
      t.datetime :signed_at

      t.timestamps
    end

    add_index :media_consents, [:student_profile_id, :season], unique: true
  end
end
