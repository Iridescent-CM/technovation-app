class RemoveTypeFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :type, :string
  end
end
