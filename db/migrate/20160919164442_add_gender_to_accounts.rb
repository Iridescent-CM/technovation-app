class AddGenderToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :gender, :integer
    add_index :accounts, :gender
  end
end
