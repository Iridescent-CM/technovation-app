class CreateParentalConsents < ActiveRecord::Migration
  def change
    create_table :parental_consents do |t|
      t.integer :consent_confirmation, null: false, default: 0
      t.string :electronic_signature, null: false
      t.references :account, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
