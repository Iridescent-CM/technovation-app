class RemoveTypeFromAccounts < ActiveRecord::Migration[4.2]
  def change
    remove_column :accounts, :type, :string
  end
end
