class AddParentRegisteredToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :parent_registered, :boolean, null: false, default: false
  end
end
