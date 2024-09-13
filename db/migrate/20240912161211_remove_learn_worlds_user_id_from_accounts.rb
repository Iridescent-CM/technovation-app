class RemoveLearnWorldsUserIdFromAccounts < ActiveRecord::Migration[6.1]
  def change
    remove_column :accounts, :learn_worlds_user_id
  end
end
