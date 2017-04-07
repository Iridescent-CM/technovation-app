class AllowNullColumnsOnAccounts < ActiveRecord::Migration[4.2]
  def change
    change_column_null :accounts, :country, true
  end
end
