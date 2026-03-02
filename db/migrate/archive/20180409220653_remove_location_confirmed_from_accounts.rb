class RemoveLocationConfirmedFromAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :location_confirmed, :boolean
  end
end
