class RenameRegionalAccountIdToAccountIdOnAccountExports < ActiveRecord::Migration
  def change
    rename_column :account_exports, :regional_ambassador_account_id, :account_id
    add_foreign_key :account_exports, :accounts
  end
end
