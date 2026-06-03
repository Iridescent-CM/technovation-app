class AddNoChaptersAvailableToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :no_chapters_available, :boolean
  end
end
