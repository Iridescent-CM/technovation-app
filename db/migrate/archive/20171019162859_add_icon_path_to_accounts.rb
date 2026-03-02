class AddIconPathToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :icon_path, :string
  end
end
