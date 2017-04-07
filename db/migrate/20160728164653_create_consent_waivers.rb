class CreateConsentWaivers < ActiveRecord::Migration[4.2]
  def change
    create_table :consent_waivers do |t|
      t.integer :consent_confirmation, null: false, default: 0
      t.string :electronic_signature, null: false
      t.references :account, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
