class AddLocationConfirmedToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :location_confirmed, :boolean
  end
end
