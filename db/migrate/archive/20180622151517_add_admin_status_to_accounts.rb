class AddAdminStatusToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :admin_status, :integer, null: false, default: 0
  end
end
