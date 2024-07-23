class RemoveSalesforceIdFromAccounts < ActiveRecord::Migration[6.1]
  def change
    remove_column :accounts, :salesforce_id
  end
end
