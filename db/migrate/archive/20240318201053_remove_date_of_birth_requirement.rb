class RemoveDateOfBirthRequirement < ActiveRecord::Migration[6.1]
  def change
    change_column_null :accounts, :date_of_birth, true
  end
end
