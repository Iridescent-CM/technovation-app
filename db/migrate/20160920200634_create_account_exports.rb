class CreateAccountExports < ActiveRecord::Migration[4.2]
  def change
    create_table :account_exports do |t|
      t.references :regional_ambassador_account, index: true, null: false
      t.string :file, null: false

      t.timestamps null: false
    end

    add_index :account_exports, :file
    add_foreign_key "account_exports", "accounts", column: "regional_ambassador_account_id"
  end
end
