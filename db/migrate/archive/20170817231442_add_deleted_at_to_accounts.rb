class AddDeletedAtToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :deleted_at, :timestamp
  end
end
