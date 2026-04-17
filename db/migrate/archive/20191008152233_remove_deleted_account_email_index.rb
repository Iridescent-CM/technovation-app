class RemoveDeletedAccountEmailIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :accounts, name: "index_accounts_on_email"
  end
end
