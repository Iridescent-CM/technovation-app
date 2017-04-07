class AddLocationConfirmedToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :location_confirmed, :boolean
  end
end
