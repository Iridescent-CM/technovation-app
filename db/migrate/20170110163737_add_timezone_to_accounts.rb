class AddTimezoneToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :timezone, :string
  end
end
