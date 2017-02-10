class AllowNullColumnsOnAccounts < ActiveRecord::Migration
  def change
    change_column_null :accounts, :country, true
  end
end
