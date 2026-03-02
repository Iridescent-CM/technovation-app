class AddSalesforceIdToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :salesforce_id, :string
  end
end
