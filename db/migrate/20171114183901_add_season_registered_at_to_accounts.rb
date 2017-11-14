class AddSeasonRegisteredAtToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :season_registered_at, :datetime
  end
end
