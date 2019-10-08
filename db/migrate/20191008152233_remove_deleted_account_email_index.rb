class RemoveDeletedAccountEmailIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :accounts, :email
  end
end
