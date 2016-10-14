class AllowNullOnCityOnAccounts < ActiveRecord::Migration
  def change
    change_column_null :accounts, :city, true
  end
end
