class AddDisabledFieldToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.boolean :disabled, null: false, default: false
    end
  end
end
