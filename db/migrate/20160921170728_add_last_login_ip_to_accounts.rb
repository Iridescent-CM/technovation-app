class AddLastLoginIpToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :last_login_ip, :string
  end
end
