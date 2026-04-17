class AddLearnWorldsUserIdToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :learn_worlds_user_id, :string
  end
end
