class AllowNullOnCityOnAccounts < ActiveRecord::Migration[4.2]
  def change
    change_column_null :accounts, :city, true
  end
end
