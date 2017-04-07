class AddBrowserOsDetailsToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :browser_name, :string
    add_column :accounts, :browser_version, :string
    add_column :accounts, :os_name, :string
    add_column :accounts, :os_version, :string
  end
end
