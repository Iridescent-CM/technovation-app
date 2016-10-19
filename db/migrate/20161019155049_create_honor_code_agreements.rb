class CreateHonorCodeAgreements < ActiveRecord::Migration
  def change
    create_table :honor_code_agreements do |t|
      t.integer :account_id, null: false, foreign_key: true
      t.string :electronic_signature, null: false
      t.boolean :agreement_confirmed, null: false, default: false
      t.date :voided_at

      t.timestamps null: false
    end
    add_index :honor_code_agreements, :account_id
  end
end
