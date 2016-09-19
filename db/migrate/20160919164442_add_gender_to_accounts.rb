class AddGenderToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :gender, :integer
    add_index :accounts, :gender
  end
end
